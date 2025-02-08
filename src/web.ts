import { WebPlugin } from "@capacitor/core";

import type {
  CapgoCapacitorDataStorageSqlitePlugin,
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
} from "./definitions";
import { Data } from "./web-utils/Data";
import { StorageDatabaseHelper } from "./web-utils/StorageDatabaseHelper";
import { isJsonStore } from "./web-utils/json-utils";

export class CapgoCapacitorDataStorageSqliteWeb
  extends WebPlugin
  implements CapgoCapacitorDataStorageSqlitePlugin
{
  private mDb!: StorageDatabaseHelper;

  async openStore(options: capOpenStorageOptions): Promise<void> {
    const dbName = options.database ? `${options.database}IDB` : "storageIDB";
    const tableName = options.table ? options.table : "storage_store";
    try {
      this.mDb = new StorageDatabaseHelper(dbName, tableName);
      return Promise.resolve();
    } catch (err: any) {
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
      return Promise.reject("SetTable: Must provide a table name");
    }
    if (this.mDb) {
      try {
        await this.mDb.setTable(tableName);
        return Promise.resolve();
      } catch (err: any) {
        return Promise.reject(`SetTable: ${err.message}`);
      }
    } else {
      return Promise.reject("SetTable: Must open a store first");
    }
  }
  async set(options: capDataStorageOptions): Promise<void> {
    const key: string = options.key;
    if (key == null || typeof key != "string") {
      return Promise.reject("Set: Must provide key as string");
    }

    const value = options.value ? options.value : null;
    if (value == null || typeof value != "string") {
      return Promise.reject("Set: Must provide value as string");
    }
    const data: Data = new Data();
    data.name = key;
    data.value = value;
    try {
      await this.mDb.set(data);
      return Promise.resolve();
    } catch (err: any) {
      return Promise.reject(`Set: ${err.message}`);
    }
  }
  async get(options: capDataStorageOptions): Promise<capValueResult> {
    const key: string = options.key;
    if (key == null || typeof key != "string") {
      return Promise.reject("Get: Must provide key as string");
    }
    try {
      const data: Data = await this.mDb.get(key);
      if (data?.value != null) {
        return Promise.resolve({ value: data.value });
      } else {
        return Promise.resolve({ value: "" });
      }
    } catch (err: any) {
      return Promise.reject(`Get: ${err.message}`);
    }
  }
  async remove(options: capDataStorageOptions): Promise<void> {
    const key: string = options.key;
    if (key == null || typeof key != "string") {
      return Promise.reject("Remove: Must provide key as string");
    }
    try {
      await this.mDb.remove(key);
      return Promise.resolve();
    } catch (err: any) {
      return Promise.reject(`Remove: ${err.message}`);
    }
  }
  async clear(): Promise<void> {
    try {
      await this.mDb.clear();
      return Promise.resolve();
    } catch (err: any) {
      return Promise.reject(`Clear: ${err.message}`);
    }
  }
  async iskey(options: capDataStorageOptions): Promise<capDataStorageResult> {
    const key: string = options.key;
    if (key == null || typeof key != "string") {
      return Promise.reject("Iskey: Must provide key as string");
    }
    try {
      const ret: boolean = await this.mDb.iskey(key);
      return Promise.resolve({ result: ret });
    } catch (err: any) {
      return Promise.reject(`Iskey: ${err.message}`);
    }
  }
  async keys(): Promise<capKeysResult> {
    try {
      const ret: string[] = await this.mDb.keys();
      return Promise.resolve({ keys: ret });
    } catch (err: any) {
      return Promise.reject(`Keys: ${err.message}`);
    }
  }
  async values(): Promise<capValuesResult> {
    try {
      const ret: string[] = await this.mDb.values();
      return Promise.resolve({ values: ret });
    } catch (err: any) {
      return Promise.reject(`Values: ${err.message}`);
    }
  }
  async filtervalues(
    options: capFilterStorageOptions,
  ): Promise<capValuesResult> {
    const filter: string = options.filter;
    if (filter == null || typeof filter != "string") {
      return Promise.reject("Filtervalues: Must provide filter as string");
    }
    let regFilter: RegExp;
    if (filter.startsWith("%")) {
      regFilter = new RegExp("^" + filter.substring(1), "i");
    } else if (filter.endsWith("%")) {
      regFilter = new RegExp(filter.slice(0, -1) + "$", "i");
    } else {
      regFilter = new RegExp(filter, "i");
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
    } catch (err: any) {
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
    } catch (err: any) {
      return Promise.reject(`Keysvalues: ${err.message}`);
    }
  }
  async deleteStore(options: capOpenStorageOptions): Promise<void> {
    throw new Error(`Method deleteStore not implemented. ${options}`);
  }
  async isTable(
    options: capTableStorageOptions,
  ): Promise<capDataStorageResult> {
    const table = options.table;
    if (table == null) {
      return Promise.reject("Must provide a Table Name");
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
    throw new Error(`Method deleteTable not implemented. ${options}`);
  }
  async importFromJson(
    options: capStoreImportOptions,
  ): Promise<capDataStorageChanges> {
    const keys = Object.keys(options);
    if (!keys.includes("jsonstring")) {
      return Promise.reject("Must provide a json object");
    }
    let totalChanges = 0;

    if (options?.jsonstring) {
      const jsonStrObj: string = options.jsonstring;
      const jsonObj = JSON.parse(jsonStrObj);
      const isValid = isJsonStore(jsonObj);
      if (!isValid) {
        return Promise.reject("Must provide a valid JsonSQLite Object");
      }
      const vJsonObj: JsonStore = jsonObj;
      const dbName = vJsonObj.database
        ? `${vJsonObj.database}IDB`
        : "storageIDB";
      for (const table of vJsonObj.tables) {
        const tableName = table.name ? table.name : "storage_store";
        try {
          this.mDb = new StorageDatabaseHelper(dbName, tableName);
          // Open the database
          const bRet: boolean = this.mDb.openStore(dbName, tableName);
          if (bRet) {
            // Import the JsonSQLite Object
            if (table?.values) {
              const changes = await this.mDb.importJson(table.values);
              totalChanges += changes;
            }
          } else {
            return Promise.reject(
              `Open store: ${dbName} : table: ${tableName} failed`,
            );
          }
        } catch (err: any) {
          return Promise.reject(`ImportFromJson: ${err.message}`);
        }
      }
      return Promise.resolve({ changes: totalChanges });
    } else {
      return Promise.reject("Must provide a json object");
    }
  }
  async isJsonValid(
    options: capStoreImportOptions,
  ): Promise<capDataStorageResult> {
    const keys = Object.keys(options);
    if (!keys.includes("jsonstring")) {
      return Promise.reject("Must provide a json object");
    }
    if (options?.jsonstring) {
      const jsonStrObj: string = options.jsonstring;
      const jsonObj = JSON.parse(jsonStrObj);
      const isValid = isJsonStore(jsonObj);
      if (!isValid) {
        return Promise.reject("Stringify Json Object not Valid");
      } else {
        return Promise.resolve({ result: true });
      }
    } else {
      return Promise.reject("Must provide in options a stringify Json Object");
    }
  }
  async exportToJson(): Promise<capStoreJson> {
    try {
      const ret: JsonStore = await this.mDb.exportJson();
      return Promise.resolve({ export: ret });
    } catch (err) {
      return Promise.reject(`exportToJson: ${err}`);
    }
  }
}
