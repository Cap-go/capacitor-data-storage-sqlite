import type {
  CapgoCapacitorDataStorageSqlitePlugin,
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
  JsonStore,
  capStoreJson,
  capDataStorageChanges,
  capStoreImportOptions,
} from '../../src/definitions';

import { Data } from './electron-utils/Data';
import { StorageDatabaseHelper } from './electron-utils/StorageDatabaseHelper';
import { isJsonStore } from './electron-utils/json-utils';

export class CapgoCapacitorDataStorageSqlite implements CapgoCapacitorDataStorageSqlitePlugin {
  mDb: StorageDatabaseHelper;
  constructor() {
    this.mDb = new StorageDatabaseHelper();
  }
  async openStore(options: capOpenStorageOptions): Promise<void> {
    const dbName = options.database ? `${options.database}SQLite.db` : 'storageSQLite.db';
    const tableName = options.table ? options.table : 'storage_store';
    try {
      await this.mDb.openStore(dbName, tableName);
      return Promise.resolve();
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async closeStore(options: capStorageOptions): Promise<void> {
    const dbName = options.database ? `${options.database}SQLite.db` : 'storageSQLite.db';
    if (this.mDb.dbName === dbName && this.mDb.isOpen) {
      try {
        await this.mDb.closeStore(dbName);
        return Promise.resolve();
      } catch (err) {
        return Promise.reject(err);
      }
    } else {
      return Promise.resolve();
    }
  }
  async isStoreOpen(options: capStorageOptions): Promise<capDataStorageResult> {
    const dbName = options.database ? `${options.database}SQLite.db` : 'storageSQLite.db';
    let ret = false;
    if (this.mDb.dbName === dbName && this.mDb.isOpen) {
      ret = true;
    }
    return Promise.resolve({ result: ret });
  }
  async isStoreExists(options: capStorageOptions): Promise<capDataStorageResult> {
    const dbName = options.database ? `${options.database}SQLite.db` : 'storageSQLite.db';
    let ret = false;
    try {
      ret = await this.mDb.isStoreExists(dbName);
      return Promise.resolve({ result: ret });
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async setTable(options: capTableStorageOptions): Promise<void> {
    const tableName = options.table;
    if (tableName == null) {
      return Promise.reject('Must provide a table name');
    }
    try {
      await this.mDb.setTable(tableName);
      return Promise.resolve();
    } catch (err) {
      return Promise.reject('Must open a store first');
    }
  }
  async set(options: capDataStorageOptions): Promise<void> {
    const key: string = options.key;
    if (key == null) {
      return Promise.reject('Must provide key');
    }
    const value: string = options.value;
    if (value == null) {
      return Promise.reject('Must provide value');
    }
    const data: Data = new Data();
    data.name = key;
    data.value = value;
    try {
      await this.mDb.set(data);
      return Promise.resolve();
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async get(options: capDataStorageOptions): Promise<capValueResult> {
    let ret: string;
    const key: string = options.key;
    if (key == null) {
      return Promise.reject('Must provide key');
    }
    try {
      const data: Data = await this.mDb.get(key);
      ret = data?.id != null ? data.value : '';
      return Promise.resolve({ value: ret });
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async remove(options: capDataStorageOptions): Promise<void> {
    try {
      const key: string = options.key;
      if (key == null) {
        return Promise.reject('Must provide key');
      }
      await this.mDb.remove(key);
      return Promise.resolve();
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async clear(): Promise<void> {
    try {
      await this.mDb.clear();
      return Promise.resolve();
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async iskey(options: capDataStorageOptions): Promise<capDataStorageResult> {
    let ret: boolean;
    const key: string = options.key;
    if (key == null) {
      return Promise.reject('Must provide key');
    }
    try {
      ret = await this.mDb.iskey(key);
      return Promise.resolve({ result: ret });
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async keys(): Promise<capKeysResult> {
    try {
      const ret: string[] = await this.mDb.keys();
      return Promise.resolve({ keys: ret });
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async values(): Promise<capValuesResult> {
    try {
      const ret: string[] = await this.mDb.values();
      return Promise.resolve({ values: ret });
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async filtervalues(options: capFilterStorageOptions): Promise<capValuesResult> {
    const filter: string = options.filter;
    if (filter == null || typeof filter != 'string') {
      return Promise.reject('Must Must provide filter as string');
    }
    try {
      const ret: string[] = await this.mDb.filtervalues(filter);
      return Promise.resolve({ values: ret });
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async keysvalues(): Promise<capKeysValuesResult> {
    const ret: any[] = [];
    try {
      const results: Data[] = await this.mDb.keysvalues();
      for (const result of results) {
        const res: any = { key: result.name, value: result.value };
        ret.push(res);
      }
      return Promise.resolve({ keysvalues: ret });
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async deleteStore(options: capOpenStorageOptions): Promise<void> {
    let dbName = options.database;
    if (dbName == null) {
      return Promise.reject('Must provide a Database Name');
    }
    dbName = `${options.database}SQLite.db`;
    try {
      await this.mDb.deleteStore(dbName);
      return Promise.resolve();
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async isTable(options: capTableStorageOptions): Promise<capDataStorageResult> {
    const table = options.table;
    if (table == null) {
      return Promise.reject('Must provide a Table Name');
    }
    try {
      const ret = await this.mDb.isTable(table);
      return Promise.resolve({ result: ret });
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async tables(): Promise<capTablesResult> {
    try {
      const ret = await this.mDb.tables();
      return Promise.resolve({ tables: ret });
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async deleteTable(options: capTableStorageOptions): Promise<void> {
    const table = options.table;
    if (table == null) {
      return Promise.reject('Must provide a Table Name');
    }
    try {
      await this.mDb.deleteTable(table);
      return Promise.resolve();
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async importFromJson(options: capStoreImportOptions): Promise<capDataStorageChanges> {
    const keys = Object.keys(options);
    if (!keys.includes('jsonstring')) {
      return Promise.reject('Must provide a json object');
    }
    let totalChanges = 0;

    if (options?.jsonstring) {
      const jsonStrObj: string = options.jsonstring;
      const jsonObj = JSON.parse(jsonStrObj);
      const isValid = isJsonStore(jsonObj);
      if (!isValid) {
        return Promise.reject('Must provide a valid JsonSQLite Object');
      }
      const vJsonObj: JsonStore = jsonObj;
      const dbName = vJsonObj.database ? `${vJsonObj.database}SQLite.db` : 'storageSQLite.db';
      for (const table of vJsonObj.tables) {
        const tableName = table.name ? table.name : 'storage_store';
        try {
          // Open the database
          await this.mDb.openStore(dbName, tableName);
          // Import the JsonSQLite Object
          if (table?.values) {
            const changes = await this.mDb.importJson(table.values);
            totalChanges += changes;
          }
        } catch (err) {
          return Promise.reject(`ImportFromJson: ${err}`);
        } finally {
          await this.mDb.closeStore(dbName);
        }
      }
      return Promise.resolve({ changes: totalChanges });
    } else {
      return Promise.reject('Must provide a json object');
    }
  }
  async isJsonValid(options: capStoreImportOptions): Promise<capDataStorageResult> {
    const keys = Object.keys(options);
    if (!keys.includes('jsonstring')) {
      return Promise.reject('Must provide a json object');
    }
    if (options?.jsonstring) {
      const jsonStrObj: string = options.jsonstring;
      const jsonObj = JSON.parse(jsonStrObj);
      const isValid = isJsonStore(jsonObj);
      if (!isValid) {
        return Promise.reject('Stringify Json Object not Valid');
      } else {
        return Promise.resolve({ result: true });
      }
    } else {
      return Promise.reject('Must provide in options a stringify Json Object');
    }
  }
  async exportToJson(): Promise<capStoreJson> {
    try {
      const ret: JsonStore = await this.mDb.exportJson();
      return Promise.resolve({ export: ret });
    } catch (err) {
      return Promise.reject(`exportToJson: ${err.message}`);
    }
  }
}
