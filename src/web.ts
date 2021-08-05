import { WebPlugin } from '@capacitor/core';

import type {
  CapacitorDataStorageSqlitePlugin,
  capEchoOptions,
  capEchoResult,
  capDataStorageOptions,
  capDataStorageResult,
  capFilterStorageOptions,
  capKeysResult,
  capKeysValuesResult,
  capTablesResult,
  capOpenStorageOptions,
  capTableStorageOptions,
  capValueResult,
  capValuesResult,
  capStorageOptions,
} from './definitions';
import { Data } from './web-utils/Data';
import { StorageDatabaseHelper } from './web-utils/StorageDatabaseHelper';

export class CapacitorDataStorageSqliteWeb
  extends WebPlugin
  implements CapacitorDataStorageSqlitePlugin {
  private mDb!: StorageDatabaseHelper;

  async echo(options: capEchoOptions): Promise<capEchoResult> {
    const ret: capEchoResult = {} as capEchoResult;
    ret.value = options.value ? options.value : '';
    return ret;
  }

  async openStore(options: capOpenStorageOptions): Promise<void> {
    const dbName = options.database ? `${options.database}IDB` : 'storageIDB';
    const tableName = options.table ? options.table : 'storage_store';
    try {
      this.mDb = new StorageDatabaseHelper(dbName, tableName);
      return Promise.resolve();
    } catch (err) {
      return Promise.reject(`OpenStore: ${err.message}`);
    }
  }
  async closeStore(options: capStorageOptions): Promise<void> {
    throw new Error(`Method closeStore not implemented. ${options}`);
  }
  async isStoreOpen(options: capStorageOptions): Promise<capDataStorageResult> {
    throw new Error(`Method isStoreOpen not implemented. ${options}`);
  }
  async isStoreExists(
    options: capStorageOptions,
  ): Promise<capDataStorageResult> {
    throw new Error(`Method isStoreExists not implemented. ${options}`);
  }
  async setTable(options: capTableStorageOptions): Promise<void> {
    const tableName = options.table;
    if (tableName == null) {
      return Promise.reject('SetTable: Must provide a table name');
    }
    if (this.mDb) {
      try {
        await this.mDb.setTable(tableName);
        return Promise.resolve();
      } catch (err) {
        return Promise.reject(`SetTable: ${err.message}`);
      }
    } else {
      return Promise.reject('SetTable: Must open a store first');
    }
  }
  async set(options: capDataStorageOptions): Promise<void> {
    const key: string = options.key;
    if (key == null || typeof key != 'string') {
      return Promise.reject('Set: Must provide key as string');
    }

    const value = options.value ? options.value : null;
    if (value == null || typeof value != 'string') {
      return Promise.reject('Set: Must provide value as string');
    }
    const data: Data = new Data();
    data.name = key;
    data.value = value;
    try {
      await this.mDb.set(data);
      return Promise.resolve();
    } catch (err) {
      return Promise.reject(`Set: ${err.message}`);
    }
  }
  async get(options: capDataStorageOptions): Promise<capValueResult> {
    const key: string = options.key;
    if (key == null || typeof key != 'string') {
      return Promise.reject('Get: Must provide key as string');
    }
    try {
      const data: Data = await this.mDb.get(key);
      if (data?.value != null) {
        return Promise.resolve({ value: data.value });
      } else {
        return Promise.resolve({ value: '' });
      }
    } catch (err) {
      return Promise.reject(`Get: ${err.message}`);
    }
  }
  async remove(options: capDataStorageOptions): Promise<void> {
    const key: string = options.key;
    if (key == null || typeof key != 'string') {
      return Promise.reject('Remove: Must provide key as string');
    }
    try {
      await this.mDb.remove(key);
      return Promise.resolve();
    } catch (err) {
      return Promise.reject(`Remove: ${err.message}`);
    }
  }
  async clear(): Promise<void> {
    try {
      await this.mDb.clear();
      return Promise.resolve();
    } catch (err) {
      return Promise.reject(`Clear: ${err.message}`);
    }
  }
  async iskey(options: capDataStorageOptions): Promise<capDataStorageResult> {
    const key: string = options.key;
    if (key == null || typeof key != 'string') {
      return Promise.reject('Iskey: Must provide key as string');
    }
    try {
      const ret: boolean = await this.mDb.iskey(key);
      return Promise.resolve({ result: ret });
    } catch (err) {
      return Promise.reject(`Iskey: ${err.message}`);
    }
  }
  async keys(): Promise<capKeysResult> {
    try {
      const ret: string[] = await this.mDb.keys();
      return Promise.resolve({ keys: ret });
    } catch (err) {
      return Promise.reject(`Keys: ${err.message}`);
    }
  }
  async values(): Promise<capValuesResult> {
    try {
      const ret: string[] = await this.mDb.values();
      return Promise.resolve({ values: ret });
    } catch (err) {
      return Promise.reject(`Values: ${err.message}`);
    }
  }
  async filtervalues(
    options: capFilterStorageOptions,
  ): Promise<capValuesResult> {
    const filter: string = options.filter;
    if (filter == null || typeof filter != 'string') {
      return Promise.reject('Filtervalues: Must provide filter as string');
    }
    let regFilter: RegExp;
    if (filter.startsWith('%')) {
      regFilter = new RegExp('^' + filter.substring(1), 'i');
    } else if (filter.endsWith('%')) {
      regFilter = new RegExp(filter.slice(0, -1) + '$', 'i');
    } else {
      regFilter = new RegExp(filter, 'i');
    }
    try {
      const ret: string[] = [];

      const results: Data[] = await this.mDb.keysvalues();
      for (const result of results) {
        if (result.name != null && regFilter.test(result.name)) {
          if (result.value != null) {
            ret.push(result.value);
          } else {
            return Promise.reject(`Filtervalues: result.value is null`);
          }
        }
      }
      return Promise.resolve({ values: ret });
    } catch (err) {
      return Promise.reject(`Filtervalues: ${err.message}`);
    }
  }
  async keysvalues(): Promise<capKeysValuesResult> {
    try {
      const ret: any[] = [];
      const results: Data[] = await this.mDb.keysvalues();
      for (const result of results) {
        if (result.name != null && result.value != null) {
          const res: any = { key: result.name, value: result.value };
          ret.push(res);
        } else {
          return Promise.reject(`Keysvalues: result.name/value are null`);
        }
      }
      return Promise.resolve({ keysvalues: ret });
    } catch (err) {
      return Promise.reject(`Keysvalues: ${err.message}`);
    }
  }
  async deleteStore(options: capOpenStorageOptions): Promise<void> {
    throw new Error(`Method deleteStore not implemented. ${options}`);
  }
  async isTable(
    options: capTableStorageOptions,
  ): Promise<capDataStorageResult> {
    throw new Error(`Method isTable not implemented. ${options}`);
  }
  async tables(): Promise<capTablesResult> {
    throw new Error('Method tables not implemented.');
  }
  async deleteTable(options: capTableStorageOptions): Promise<void> {
    throw new Error(`Method deleteTable not implemented. ${options}`);
  }
}
