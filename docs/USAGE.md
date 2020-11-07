<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h2 align="center">USAGE DOCUMENTATION</h2>
<p align="center"><strong><code>capacitor-data-storage-sqlite</code></strong></p>
<p align="center">
  Capacitor Data Storage SQlite Plugin can be used in several frameworks, either through its own API or through Wrappers or Hooks.</p>

## Frameworks Index

- [`javascript`](#Javascript)
- [`Stencil`](#Stencil)
- [`React`](#React)
- [`Vue`](#Vue)
- [`Ionic/Angular`](#Ionic/Angular)
- [`Ionic/React`](#Ionic/React)
- [`Ionic/Vue`](#Ionic/Vue)

## Usage

### Javascript

Through a wrapper to adhere to the Storage API

(https://developer.mozilla.org/de/docs/Web/API/Storage)

- Javascript wrapper

```js
export const StorageAPIWrapper = storage => {
  return {
    openStore: (options, cb) => {
      storage
        .openStore(options)
        .then(({ result }) => cb(result))
        .catch(cb);
    },
    setTable: (table, cb) => {
      storage
        .setTable(table)
        .then(({ result, message }) => cb(result, message))
        .catch(cb);
    },
    getAllKeys: cb => {
      storage
        .keys()
        .then(({ keys }) => cb(keys))
        .catch(cb);
    },
    getAllValues: cb => {
      storage
        .values()
        .then(({ values }) => cb(values))
        .catch(cb);
    },
    getFilterValues: (filter, cb) => {
      storage
        .filtervalues(filter)
        .then(({ values }) => cb(values))
        .catch(cb);
    },
    getAllKeysValues: cb => {
      storage
        .keysvalues()
        .then(({ keysvalues }) => cb(keysvalues))
        .catch(cb);
    },
    getItem: (key, cb) => {
      storage
        .get({ key })
        .then(({ value }) => cb(value))
        .catch(cb);
    },
    setItem: (key, value, cb) => {
      storage
        .set({ key, value })
        .then(({ result }) => cb(result))
        .catch(cb);
    },
    isKey: (key, cb) => {
      storage
        .iskey({ key })
        .then(({ result }) => cb(result))
        .catch(cb);
    },
    removeItem: (key, cb) => {
      storage
        .remove({ key })
        .then(({ result }) => cb(result))
        .catch(cb);
    },
    clear: cb => {
      storage
        .clear()
        .then(({ result }) => cb(result))
        .catch(cb);
    },
    deleteStore: (options, cb) => {
      storage
        .deleteStore(options)
        .then(({ result }) => cb(result))
        .catch(cb);
    },
  };
};
```

- usage example

```js
import { Capacitor, Plugins } from '@capacitor/core';
import 'capacitor-data-storage-sqlite';

  ...
    const { CapacitorDataStorageSqlite } = Plugins;
    const platform = Capacitor.getPlatform();
    console.log("*** platform " + platform);
    const storageSQLite = CapacitorDataStorageSqlite;
    const wrapper = new StorageAPIWrapper(storageSQLite);

  ...
    console.log("**** Starting Test Wrapper Store ****\n");
    // open store

    wrapper.openStore({database:"wrapperStore",table:"wrapperData"}, (res) => {
      if( !res ) {
        console.log("openStore failed \n");
      } else {
        console.log(" openStore was successful ", res)
        wrapper.clear( res => {
          if( !res ) {
            console.log("clear failed \n");
          } else {
            console.log("clear was successful \n");
            wrapper.setItem("session","Session Opened",(res) => {
                if( !res ) {
                console.log("clear failed \n");
                } else {
                    wrapper.getItem('session', (value) => {
                        if(value != "Session Opened") {
                        console.log("setItem/getItem session failed \n");
                        } else {
                        console.log("setItem/getItem session was successful \n");
                        wrapper.isKey('session', (res) => {
                            if( !res ) {
                            console.log("isKey failed \n");
                            } else {
                            console.log("isKey was successful \n");
                            var msg = "\n**** Test Wrapper Store was ";
                            msg += "successful ****\n"
                            console.log(msg);
                            }
                        });
                        }
                    });
                }
            });
          }
        });
      }
    });

  ...
```

### Stencil

In your component

```ts
import {  CapacitorDataStorageSqlite } from 'capacitor-data-storage-sqlite';
  @Component( ... )
  export class MyApp {
    ...
    componentDidLoad() {
    const storage: any = CapacitorDataStorageSqlite;
    // Open the Store
    let resOpen:any = await storage.openStore({});
    if(resOpen) {
      // Store Data
      let result:any = await storage.set({key:"session", value:"Session Opened"});
      console.log("Save Data : " + result.result);
      // Retrieve Data
      result = await storage.get({key:"session"})
      console.log("Get Data : " + result.value);
      ...
    }
    ...
  }
```

### React

- a React Hook has been developed to easy the use of the plugin
  [react-data-storage-sqlite-hook](https://github.com/jepiqueau/react-data-storage-sqlite-hook)

- a React app has been developed to demonstrate the use of the plugin
  [react-datastoragesqlite-app](https://github.com/jepiqueau/react-datastoragesqlite-app)

- usage basic example

```js
 ...
 import { useStorageSQLite } from 'react-data-storage-sqlite-hook/dist';

 ...
 const [log, setLog] = useState<string[]>([]);

 const {openStore, getItem, setItem, getAllKeys, getAllValues,
        getFilterValues, getAllKeysValues, isKey, setTable,
        removeItem, clear} = useStorageSQLite();
 useEffect(() => {
   async function testSimpleStore() {
     setLog((log) => log.concat("Tab 2 page\n"));
     const resOpen =  await openStore({});
     if(resOpen) {
       await setItem('name', 'Jeep');
       const val = await getItem('name');
       await setItem('message', 'Hello World from ');
       const mess = await getItem('message');
       if( mess && val ) setLog((log) => log.concat(mess + val + "\n"));
       const keys = await getAllKeys();
       setLog((log) => log.concat("keys : " + keys.length + "\n"));
       for(let i: number = 0;i< keys.length;i++) {
         setLog((log) => log.concat('key[' + i + "] = " + keys[i] + "\n"));
       }
       const values = await getAllValues();
       setLog((log) => log.concat("values : " + values.length + "\n"));
       for(let i: number = 0;i< values.length;i++) {
         setLog((log) => log.concat('value[' + i + "] = " + values[i] + "\n"));
       }
       const keysvalues = await getAllKeysValues();
       setLog((log) => log.concat("keysvalues : " + keysvalues.length + "\n"));
       for(let i: number = 0;i< keysvalues.length;i++) {
         setLog((log) => log.concat(' key[' + i + "] = " + keysvalues[i].key +
           ' value[' + i + "] = " + keysvalues[i].value  + "\n"));
       }
       const iskey = await isKey('name');
       setLog((log) => log.concat('iskey name ' + iskey + "\n"));
     }
   }
   testSimpleStore();
 }, [ openStore, getItem, setItem, getAllKeys, getAllValues, getFilterValues,
      getAllKeysValues, isKey, setTable, removeItem, clear]);

 ...
```

### Vue

- a Vue Hook has been developed to easy the use of the plugin
  [vue-data-storage-sqlite-hook](https://github.com/jepiqueau/vue-data-storage-sqlite-hook)

- a Vue app has been developed to demonstrate the use of the plugin
  [vue-datastoragesqlite-app](https://github.com/jepiqueau/vue-datastoragesqlite-app)

- usage basic example

```html
...
<script>
  import { defineComponent, ref } from 'vue';
  import { useStorageSQLite } from 'vue-data-storage-sqlite-hook/dist';
  export default defineComponent({
    name: 'DefaultTest',
    async setup() {
      const log = ref('');
      const {
        openStore,
        getItem,
        setItem,
        getAllKeys,
        getAllValues,
        getAllKeysValues,
        isKey,
        removeItem,
        clear,
      } = useStorageSQLite();
      log.value = log.value.concat('**** Starting Test Default Store ****\n');
      // open store
      const resOpen = await openStore({
        database: 'vueStore',
        table: 'vueData',
      });
      if (!resOpen) {
        log.value = log.value.concat('openStore failed \n');
        return { log };
      }
      // store a string
      await setItem('session', 'Session Opened');
      const session = await getItem('session');
      if (session != 'Session Opened') {
        log.value = log.value.concat('setItem/getItem session failed \n');
        return { log };
      }
      // store a JSON Object in the default store
      const data = { a: 20, b: 'Hello World', c: { c1: 40, c2: 'cool' } };
      await setItem('testJson', JSON.stringify(data));
      const testJson = await getItem('testJson');
      if (testJson != JSON.stringify(data)) {
        log.value = log.value.concat('setItem/getItem testJson failed \n');
        return { log };
      }
      // store a number in the default store
      const data1 = 243.567;
      await setItem('testNumber', data1.toString());
      // read number from the store
      const testNumber = await getItem('testNumber');
      if (testNumber != data1) {
        log.value = log.value.concat('setItem/getItem testNumber failed \n');
        return { log };
      }
      // isKey tests
      const iskey = await isKey('testNumber');
      if (!iskey) {
        log.value = log.value.concat('isKey testNumber failed \n');
        return { log };
      }
      // Get All Keys
      const keys = await getAllKeys();
      if (keys.length != 3) {
        log.value = log.value.concat('getAllKeys failed \n');
        return { log };
      } else {
        for (let i = 0; i < keys.length; i++) {
          log.value = log.value.concat(' key[' + i + '] = ' + keys[i] + '\n');
        }
      }
      // Get All KeysValues
      const keysvalues = await getAllKeysValues();
      if (keysvalues.length != 3) {
        log.value = log.value.concat('getAllKeysValues failed \n');
        return { log };
      }
      // Remove a key
      const res = await removeItem('testJson');
      if (!res) {
        log.value = log.value.concat('removeItem failed \n');
        return { log };
      }
      log.value = log.value.concat(
        '\n**** Test Default Store was successful ****\n',
      );
      return { log };
    },
  });
</script>
```

### Ionic/Angular

- define a service

```ts
import { Injectable } from '@angular/core';

import { Plugins } from '@capacitor/core';
import 'capacitor-data-storage-sqlite';
const { CapacitorDataStorageSqlite, Device } = Plugins;

@Injectable({
  providedIn: 'root',
})
export class StoreService {
  store: any;
  isService: boolean = false;
  platform: string;
  constructor() {}
  /**
   * Plugin Initialization
   */
  async init(): Promise<void> {
    const info = await Device.getInfo();
    this.platform = info.platform;
    this.store = CapacitorDataStorageSqlite;
    this.isService = true;
    console.log('in init ', this.platform, this.isService);
  }
  /**
   * Open a Database
   * @param _dbName string optional
   * @param _table string optional
   * @param _encrypted boolean optional
   * @param _mode string optional
   */
  async openStore(
    _dbName?: string,
    _table?: string,
    _encrypted?: boolean,
    _mode?: string,
  ): Promise<boolean> {
    if (this.isService) {
      const database: string = _dbName ? _dbName : 'storage';
      const table: string = _table ? _table : 'storage_table';
      const encrypted: boolean = _encrypted ? _encrypted : false;
      const mode: string = _mode ? _mode : 'no-encryption';
      const { result } = await this.store.openStore({
        database,
        table,
        encrypted,
        mode,
      });
      console.log('*** result in openStore', result);
      return result;
    } else {
      return Promise.resolve(false);
    }
  }
  /**
   * Create/Set a Table
   * @param table string
   */
  async setTable(table: string): Promise<any> {
    if (this.isService) {
      const { result, message } = await this.store.setTable({ table });
      return Promise.resolve([result, message]);
    } else {
      return Promise.resolve({
        result: false,
        message: 'Service is not initialized',
      });
    }
  }
  /**
   * Set of Key
   * @param key string
   * @param value string
   */
  async setItem(key: string, value: string): Promise<void> {
    if (this.isService && key.length > 0) {
      await this.store.set({ key, value });
    }
  }
  /**
   * Get the Value for a given Key
   * @param key string
   */
  async getItem(key: string): Promise<string> {
    if (this.isService && key.length > 0) {
      const { value } = await this.store.get({ key });
      console.log('in getItem value ', value);
      return value;
    } else {
      return null;
    }
  }
  async isKey(key: string): Promise<boolean> {
    if (this.isService && key.length > 0) {
      const { result } = await this.store.iskey({ key });
      return result;
    } else {
      return null;
    }
  }
  async getAllKeys(): Promise<Array<string>> {
    if (this.isService) {
      const { keys } = await this.store.keys();
      return keys;
    } else {
      return null;
    }
  }
  async getAllValues(): Promise<Array<string>> {
    if (this.isService) {
      const { values } = await this.store.values();
      return values;
    } else {
      return null;
    }
  }
  async getFilterValues(filter: string): Promise<Array<string>> {
    if (this.isService) {
      const { values } = await this.store.filtervalues({ filter });
      return values;
    } else {
      return null;
    }
  }
  async getAllKeysValues(): Promise<Array<any>> {
    if (this.isService) {
      const { keysvalues } = await this.store.keysvalues();
      return keysvalues;
    } else {
      return null;
    }
  }

  async removeItem(key: string): Promise<boolean> {
    if (this.isService && key.length > 0) {
      const { result } = await this.store.remove({ key });
      return result;
    } else {
      return null;
    }
  }
  async clear(): Promise<boolean> {
    if (this.isService) {
      const { result } = await this.store.clear();
      return result;
    } else {
      return null;
    }
  }
  async deleteStore(_dbName?: string): Promise<boolean> {
    const database: string = _dbName ? _dbName : 'storage';
    await this.init();
    if (this.isService) {
      const { result } = await this.store.deleteStore({ database });
      return result;
    }
    return;
  }
}
```

and then use it in YOUR_COMPONENT

```ts
import { Component, AfterViewInit } from '@angular/core';
import { StoreService } from '../../services/store.service';

@Component({
  selector: 'app-filterkeys',
  templateUrl: './filterkeys.component.html',
  styleUrls: ['./filterkeys.component.scss'],
})
export class FilterKeysComponent implements AfterViewInit {
  platform: string;
  isService: boolean = false;
  store: any = null;
  _cardStorage: HTMLIonCardElement;

  constructor(private _StoreService: StoreService) {}
  /*******************************
   * Component Lifecycle Methods *
   *******************************/

  async ngAfterViewInit() {
    // Initialize the CapacitorDataStorageSQLite plugin
    await this._StoreService.init();
  }

  /*******************************
   * Component Methods           *
   *******************************/

  async runTests(): Promise<void> {
    this._cardStorage = document.querySelector('.card-filter');

    if (this._StoreService.isService) {
      // reset the Dom in case of multiple runs
      await this.resetStorageDisplay();

      const retFirst: boolean = await this.testFilterKeys();
      console.log('retFirst : ', retFirst);
      if (retFirst) {
        document.querySelector('.filter-success1').classList.remove('display');
      } else {
        document.querySelector('.filter-failure1').classList.remove('display');
      }
    } else {
      console.log('Service is not initialized');
      document.querySelector('.filter-failure1').classList.remove('display');
    }
  }
  async testFilterKeys(): Promise<boolean> {
    console.log('in testFilterKeys start ***** ');
    let result: any = await this._StoreService.openStore(
      'filterStore',
      'filterData',
    );
    console.log('openStore "filterStore" result', result);
    if (!result) {
      console.log('openStore "filterStore" failed to open');
    }
    await this._StoreService.clear();
    // store data in the filter store
    await this._StoreService.setItem('session', 'Session Lowercase Opened');
    let json: any = { a: 20, b: 'Hello World', c: { c1: 40, c2: 'cool' } };
    await this._StoreService.setItem('testJson', JSON.stringify(json));
    await this._StoreService.setItem('Session1', 'Session Uppercase 1 Opened');
    await this._StoreService.setItem(
      'MySession2foo',
      'Session Uppercase 2 Opened',
    );
    const num: number = 243.567;
    await this._StoreService.setItem('testNumber', num.toString());
    await this._StoreService.setItem(
      'Mylsession2foo',
      'Session Lowercase 2 Opened',
    );
    await this._StoreService.setItem(
      'EnduSession',
      'Session Uppercase End Opened',
    );
    await this._StoreService.setItem(
      'Endlsession',
      'Session Lowercase End Opened',
    );
    await this._StoreService.setItem('SessionReact', 'Session React Opened');
    // Get All Values
    const values: string[] = await this._StoreService.getAllValues();
    if (values.length != 9) {
      console.log('getAllValues failed \n');
      return false;
    } else {
      for (let i = 0; i < values.length; i++) {
        console.log(' key[' + i + '] = ' + values[i] + '\n');
      }
    }
    // Get Filter Values Starting with "session"
    const stValues: string[] = await this._StoreService.getFilterValues(
      '%session',
    );
    if (stValues.length != 3) {
      console.log('getFilterValues Start failed \n');
      return false;
    } else {
      for (let i = 0; i < stValues.length; i++) {
        console.log(' key[' + i + '] = ' + stValues[i] + '\n');
      }
    }
    // Get Filter Values Ending with "session"
    const endValues: string[] = await this._StoreService.getFilterValues(
      'session%',
    );
    if (endValues.length != 3) {
      console.log('getFilterValues End failed \n');
      return false;
    } else {
      for (let i = 0; i < endValues.length; i++) {
        console.log(' key[' + i + '] = ' + endValues[i] + '\n');
      }
    }
    // Get Filter Values Containing "session"
    const contValues: string[] = await this._StoreService.getFilterValues(
      'session',
    );
    if (contValues.length != 7) {
      console.log('getFilterValues End failed \n');
      return false;
    } else {
      for (let i = 0; i < contValues.length; i++) {
        console.log(' key[' + i + '] = ' + contValues[i] + '\n');
      }
    }
    console.log('in testFilterKeys end ***** ');

    return true;
  }
  async resetStorageDisplay(): Promise<void> {
    for (let i: number = 0; i < this._cardStorage.childElementCount; i++) {
      if (!this._cardStorage.children[i].classList.contains('display'))
        this._cardStorage.children[i].classList.add('display');
    }
  }
}
```

### Ionic/React

- a React Hook has been developed to easy the use of the plugin
  [react-data-storage-sqlite-hook](https://github.com/jepiqueau/react-data-storage-sqlite-hook)

- a React app has been developed to demonstrate the use of the plugin
  [react-data-storage-sqlite-app-starter](https://github.com/jepiqueau/react-data-storage-sqlite-app-starter)

- usage basic example

```ts
import React, { useState, useEffect } from 'react';
import {
  IonContent,
  IonHeader,
  IonPage,
  IonTitle,
  IonToolbar,
} from '@ionic/react';
import './Tab2.css';
import { useStorageSQLite } from 'react-data-storage-sqlite-hook/dist';

const Tab2: React.FC = () => {
  const [log, setLog] = useState<string[]>([]);

  const {
    openStore,
    getItem,
    setItem,
    getAllKeys,
    getAllValues,
    getAllKeysValues,
    isKey,
    setTable,
    removeItem,
    clear,
  } = useStorageSQLite();
  useEffect(() => {
    async function testSimpleStore() {
      setLog(log => log.concat('Tab 2 page\n'));
      const resOpen = await openStore({});
      if (resOpen) {
        await setItem('name', 'Jeep');
        const val = await getItem('name');
        await setItem('message', 'Hello World from ');
        const mess = await getItem('message');
        if (mess && val) setLog(log => log.concat(mess + val + '\n'));

        const keys = await getAllKeys();
        setLog(log => log.concat('keys : ' + keys.length + '\n'));
        for (let i: number = 0; i < keys.length; i++) {
          setLog(log => log.concat('key[' + i + '] = ' + keys[i] + '\n'));
        }
        const values = await getAllValues();
        setLog(log => log.concat('values : ' + values.length + '\n'));
        for (let i: number = 0; i < values.length; i++) {
          setLog(log => log.concat('value[' + i + '] = ' + values[i] + '\n'));
        }
        const keysvalues = await getAllKeysValues();
        setLog(log => log.concat('keysvalues : ' + keysvalues.length + '\n'));
        for (let i: number = 0; i < keysvalues.length; i++) {
          setLog(log =>
            log.concat(
              ' key[' +
                i +
                '] = ' +
                keysvalues[i].key +
                ' value[' +
                i +
                '] = ' +
                keysvalues[i].value +
                '\n',
            ),
          );
        }
        const iskey = await isKey('name');
        setLog(log => log.concat('iskey name ' + iskey + '\n'));
        const iskey1 = await isKey('foo');
        setLog(log => log.concat('iskey foo ' + iskey1 + '\n'));
        const r = await setTable('testtable');
        setLog(log =>
          log.concat(
            'set table "testtable" result ' +
              r.result +
              ' message ' +
              r.message +
              '\n',
          ),
        );
        console.log('r ' + r.result + ' message ' + r.message);
        if (r.result) {
          await setItem('name', 'Jeepq');
          await setItem('email', 'Jeepq@example.com');
          await setItem('tel', '2255443315');
          const name = await getItem('name');
          if (name) setLog(log => log.concat(name + '\n'));
          const email = await getItem('email');
          if (email) setLog(log => log.concat(email + '\n'));
          const tel = await getItem('tel');
          if (tel) setLog(log => log.concat(tel + '\n'));
          const res = await removeItem('tel');
          if (res) setLog(log => log.concat('remove tel ' + res + '\n'));
          const iskey = await isKey('tel');
          setLog(log => log.concat('iskey tel ' + iskey + '\n'));
          const rClear = await clear();
          if (rClear)
            setLog(log => log.concat('clear table "testtable" ' + res + '\n'));
        }
      }
    }
    testSimpleStore();
  }, [
    openStore,
    getItem,
    setItem,
    getAllKeys,
    getAllValues,
    getAllKeysValues,
    isKey,
    setTable,
    removeItem,
    clear,
  ]);

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Tab 2</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent fullscreen>
        <IonHeader collapse="condense">
          <IonToolbar>
            <IonTitle size="large">Tab 2</IonTitle>
          </IonToolbar>
        </IonHeader>
        <pre>
          <p>{log}</p>
        </pre>
      </IonContent>
    </IonPage>
  );
};

export default Tab2;
```

### Ionic/Vue

- a Vue Hook has been developed to easy the use of the plugin
  [vue-data-storage-sqlite-hook](https://github.com/jepiqueau/vue-data-storage-sqlite-hook)

- a Vue app has been developed to demonstrate the use of the plugin
  [vue-data-storage-sqlite-app-starter](https://github.com/jepiqueau/vue-data-storage-sqlite-app-starter)

- usage basic example

  Defining a component with

  ```html
  <template>
    <div id="filter-values-container">
      <div id="log">
        <pre>
              <p>{{log}}</p>
              </pre
        >
      </div>
    </div>
  </template>

  <script lang="ts">
    import { defineComponent, ref } from 'vue';
    import { useStorageSQLite } from 'vue-data-storage-sqlite-hook/dist';

    export default defineComponent({
      name: 'FilterValuesTest',
      async setup() {
        const log = ref('');
        const {
          openStore,
          setItem,
          getFilterValues,
          getAllValues,
          clear,
        } = useStorageSQLite();
        log.value = log.value.concat('**** Starting Test Filter Values ****\n');

        // open store
        const resOpen: boolean = await openStore({
          database: 'filterStore',
          table: 'saveData',
        });
        if (!resOpen) {
          log.value = log.value.concat('openStore failed \n');
          return { log };
        }
        // store data
        await setItem('session', 'Session Lowercase Opened');
        const data = { a: 20, b: 'Hello World', c: { c1: 40, c2: 'cool' } };
        await setItem('testJson', JSON.stringify(data));
        await setItem('Session1', 'Session Uppercase 1 Opened');
        await setItem('MySession2foo', 'Session Uppercase 2 Opened');
        const data1 = 243.567;
        await setItem('testNumber', data1.toString());
        await setItem('Mylsession2foo', 'Session Lowercase 2 Opened');
        await setItem('EnduSession', 'Session Uppercase End Opened');
        await setItem('Endlsession', 'Session Lowercase End Opened');
        await setItem('SessionReact', 'Session React Opened');
        // Get All Values
        const values: string[] = await getAllValues();
        if (values.length != 9) {
          log.value = log.value.concat('getAllValues failed \n');
          return { log };
        } else {
          for (let i = 0; i < values.length; i++) {
            log.value = log.value.concat(
              ' key[' + i + '] = ' + values[i] + '\n',
            );
          }
        }

        // Get Filter Values Starting with "session"
        const stValues: string[] = await getFilterValues('%session');
        if (stValues.length != 3) {
          log.value = log.value.concat('getFilterValues Start failed \n');
          return { log };
        } else {
          for (let i = 0; i < stValues.length; i++) {
            log.value = log.value.concat(
              ' key[' + i + '] = ' + stValues[i] + '\n',
            );
          }
        }
        // Get Filter Values Ending with "session"
        const endValues: string[] = await getFilterValues('session%');
        if (endValues.length != 3) {
          log.value = log.value.concat('getFilterValues End failed \n');
          return { log };
        } else {
          for (let i = 0; i < endValues.length; i++) {
            log.value = log.value.concat(
              ' key[' + i + '] = ' + endValues[i] + '\n',
            );
          }
        }
        // Get Filter Values Containing "session"
        const contValues: string[] = await getFilterValues('session');
        if (contValues.length != 7) {
          log.value = log.value.concat('getFilterValues End failed \n');
          return { log };
        } else {
          for (let i = 0; i < contValues.length; i++) {
            log.value = log.value.concat(
              ' key[' + i + '] = ' + contValues[i] + '\n',
            );
          }
        }
        log.value = log.value.concat(
          '\n**** Test Filter Values was successful ****\n',
        );
        return { log };
      },
    });
  </script>
  ```

  Defining a view to call the component

  ```html
  <template>
    <ion-page>
      <ion-header>
        <ion-toolbar>
          <ion-buttons slot="start">
            <ion-back-button default-href="/tabs/tab2"></ion-back-button>
          </ion-buttons>
          <ion-title>StoreFilterValues</ion-title>
        </ion-toolbar>
      </ion-header>
      <ion-content :fullscreen="true">
        <ion-header collapse="condense">
          <ion-toolbar>
            <ion-title size="large">StoreFilterValues</ion-title>
          </ion-toolbar>
        </ion-header>
        <ion-card>
          <ion-card-content>
            <Suspense>
              <template #default>
                <FilterValuesTest />
              </template>
              <template #feedback>
                <div>Loading ...</div>
              </template>
            </Suspense>
          </ion-card-content>
        </ion-card>
      </ion-content>
    </ion-page>
  </template>
  <script lang="ts">
    import {
      IonPage,
      IonButtons,
      IonHeader,
      IonToolbar,
      IonBackButton,
      IonTitle,
      IonContent,
      IonCard,
      IonCardContent,
    } from '@ionic/vue';
    import { defineComponent } from 'vue';
    import FilterValuesTest from '@/components/FilterValuesTest.vue';
    export default defineComponent({
      name: 'StoreFilterValues',
      components: {
        IonPage,
        IonButtons,
        IonHeader,
        IonToolbar,
        IonBackButton,
        IonTitle,
        IonContent,
        IonCard,
        IonCardContent,
        FilterValuesTest,
      },
    });
  </script>
  <style>
    h1 {
      text-align: center;
    }
  </style>
  ```
