
import './style.css';
import { CapgoCapacitorDataStorageSqlite } from '@capgo/capacitor-data-storage-sqlite';

const plugin = CapgoCapacitorDataStorageSqlite;
const state = {};
state.database = undefined; state.table = undefined;

const actions = [
{
              id: 'open-store',
              label: 'Open store',
              description: 'Opens (or creates) a store. Call this before other operations.',
              inputs: [{ name: 'database', label: 'Database name', type: 'text', value: 'example_store' }, { name: 'table', label: 'Table name', type: 'text', value: 'example_table' }],
              run: async (values) => {
                const database = values.database || 'example_store';
const table = values.table || 'example_table';
await plugin.openStore({ database, table });
state.database = database;
state.table = table;
return `Store ${database}/${table} opened.`;
              },
            },
{
              id: 'set-value',
              label: 'Set key/value',
              description: 'Persists a key/value pair in the current store.',
              inputs: [{ name: 'key', label: 'Key', type: 'text', value: 'greeting' }, { name: 'value', label: 'Value', type: 'text', value: 'Hello from example-app' }],
              run: async (values) => {
                await plugin.set({ key: values.key || 'greeting', value: values.value ?? '' });
return 'Value saved.';
              },
            },
{
              id: 'get-value',
              label: 'Get value',
              description: 'Reads a value for the provided key.',
              inputs: [{ name: 'key', label: 'Key', type: 'text', value: 'greeting' }],
              run: async (values) => {
                const result = await plugin.get({ key: values.key || 'greeting' });
return result;
              },
            },
{
  id: 'list-keys-values',
  label: 'List keys/values',
  description: 'Returns all stored key/value pairs.',
  inputs: [],
  run: async (values) => {
    return await plugin.keysvalues();
  },
},
{
              id: 'clear-store',
              label: 'Clear store',
              description: 'Removes all keys from the currently opened store.',
              inputs: [],
              run: async (values) => {
                await plugin.clear();
return 'Store cleared.';
              },
            },
{
              id: 'close-store',
              label: 'Close store',
              description: 'Closes the opened store.',
              inputs: [{ name: 'database', label: 'Database name', type: 'text', placeholder: 'Leave blank to reuse last opened store' }],
              run: async (values) => {
                const database = values.database || state.database || 'example_store';
await plugin.closeStore({ database });
return `Store ${database} closed.`;
              },
            }
];

const actionSelect = document.getElementById('action-select');
const formContainer = document.getElementById('action-form');
const descriptionBox = document.getElementById('action-description');
const runButton = document.getElementById('run-action');
const output = document.getElementById('plugin-output');

function buildForm(action) {
  formContainer.innerHTML = '';
  if (!action.inputs || !action.inputs.length) {
    const note = document.createElement('p');
    note.className = 'no-input-note';
    note.textContent = 'This action does not require any inputs.';
    formContainer.appendChild(note);
    return;
  }
  action.inputs.forEach((input) => {
    const fieldWrapper = document.createElement('div');
    fieldWrapper.className = input.type === 'checkbox' ? 'form-field inline' : 'form-field';

    const label = document.createElement('label');
    label.textContent = input.label;
    label.htmlFor = `field-${input.name}`;

    let field;
    switch (input.type) {
      case 'textarea': {
        field = document.createElement('textarea');
        field.rows = input.rows || 4;
        break;
      }
      case 'select': {
        field = document.createElement('select');
        (input.options || []).forEach((option) => {
          const opt = document.createElement('option');
          opt.value = option.value;
          opt.textContent = option.label;
          if (input.value !== undefined && option.value === input.value) {
            opt.selected = true;
          }
          field.appendChild(opt);
        });
        break;
      }
      case 'checkbox': {
        field = document.createElement('input');
        field.type = 'checkbox';
        field.checked = Boolean(input.value);
        break;
      }
      case 'number': {
        field = document.createElement('input');
        field.type = 'number';
        if (input.value !== undefined && input.value !== null) {
          field.value = String(input.value);
        }
        break;
      }
      default: {
        field = document.createElement('input');
        field.type = 'text';
        if (input.value !== undefined && input.value !== null) {
          field.value = String(input.value);
        }
      }
    }

    field.id = `field-${input.name}`;
    field.name = input.name;
    field.dataset.type = input.type || 'text';

    if (input.placeholder && input.type !== 'checkbox') {
      field.placeholder = input.placeholder;
    }

    if (input.type === 'checkbox') {
      fieldWrapper.appendChild(field);
      fieldWrapper.appendChild(label);
    } else {
      fieldWrapper.appendChild(label);
      fieldWrapper.appendChild(field);
    }

    formContainer.appendChild(fieldWrapper);
  });
}

function getFormValues(action) {
  const values = {};
  (action.inputs || []).forEach((input) => {
    const field = document.getElementById(`field-${input.name}`);
    if (!field) return;
    switch (input.type) {
      case 'number': {
        values[input.name] = field.value === '' ? null : Number(field.value);
        break;
      }
      case 'checkbox': {
        values[input.name] = field.checked;
        break;
      }
      default: {
        values[input.name] = field.value;
      }
    }
  });
  return values;
}

function setAction(action) {
  descriptionBox.textContent = action.description || '';
  buildForm(action);
  output.textContent = 'Ready to run the selected action.';
}

function populateActions() {
  actionSelect.innerHTML = '';
  actions.forEach((action) => {
    const option = document.createElement('option');
    option.value = action.id;
    option.textContent = action.label;
    actionSelect.appendChild(option);
  });
  setAction(actions[0]);
}

actionSelect.addEventListener('change', () => {
  const action = actions.find((item) => item.id === actionSelect.value);
  if (action) {
    setAction(action);
  }
});

runButton.addEventListener('click', async () => {
  const action = actions.find((item) => item.id === actionSelect.value);
  if (!action) return;
  const values = getFormValues(action);
  try {
    const result = await action.run(values);
    if (result === undefined) {
      output.textContent = 'Action completed.';
    } else if (typeof result === 'string') {
      output.textContent = result;
    } else {
      output.textContent = JSON.stringify(result, null, 2);
    }
  } catch (error) {
    output.textContent = `Error: ${error?.message ?? error}`;
  }
});

populateActions();
