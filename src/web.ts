import { WebPlugin } from '@capacitor/core';
import { StorageDatabaseHelper } from './web-utils/StorageDatabaseHelper';
import { Data } from './web-utils/Data';
import { CapacitorDataStorageSqlitePlugin, capDataStorageOptions, capDataStorageResult , capOpenStorageOptions } from './definitions';

export class CapacitorDataStorageSqliteWeb extends WebPlugin implements CapacitorDataStorageSqlitePlugin {
  mDb:StorageDatabaseHelper;
  constructor() {
    super({
      name: 'CapacitorDataStorageSqlite',
      platforms: ['web']
    });
  }

  async echo(options: { value: string }): Promise<{value: string}> {
    console.log('ECHO', options);
    return options;
  }

  async openStore(options: capOpenStorageOptions): Promise<capDataStorageResult> {
    let ret: boolean = false;
    let dbName = options.database ? `${options.database}IDB` : "storageIDB";
    let tableName = options.table ? options.table : "storage_store";
    this.mDb = new StorageDatabaseHelper(dbName,tableName);
    if(this.mDb) ret = true;
    return Promise.resolve({result:ret});
  }

  async setTable(options: capOpenStorageOptions): Promise<capDataStorageResult> {
    let tableName = options.table;
    if (tableName == null) {
      return Promise.reject("Must provide a table name");
    }
    let ret: boolean = false;
    let message: string = "";
    if(this.mDb) {
      ret = await this.mDb.setTable(tableName);
      if (ret) {
        return Promise.resolve({result:ret, message:message});
      } else {
        return Promise.resolve({result:ret, message:"failed in adding table"});
      }
    } else {
      return Promise.resolve({result:ret, message:"Must open a store first"});
    }
  }
  async set(options: capDataStorageOptions): Promise<capDataStorageResult> {
    let ret: boolean;
    let key:string = options.key;
    if (key == null) {
      return Promise.reject("Must provide key");
    }
    let value: string = options.value;
    if (value == null) {
      return Promise.reject("Must provide value");
    }
    let data:Data = new Data();
    data.name = key;
    data.value = value;
    ret = await this.mDb.set(data);
    return Promise.resolve({result:ret});
  }

  async get(options: capDataStorageOptions): Promise<capDataStorageResult> {
    let ret:  string;
    let key:string = options.key;
    if (key == null) {
      return Promise.reject("Must provide key");
    }
    let data: Data = await this.mDb.get(key);
    ret = data != null ? data.value : null;
    return Promise.resolve({value: ret});
  }

  async remove(options: capDataStorageOptions): Promise<capDataStorageResult> {
    let ret: boolean;
    let key:string = options.key;
    if (key == null) {
      return Promise.reject("Must provide key");
    }
    ret = await this.mDb.remove(key);
    return Promise.resolve({result:ret});
  }

  async clear(): Promise<capDataStorageResult> {
    let ret: boolean;
    ret = await this.mDb.clear();
    return Promise.resolve({result:ret});
  }

  async iskey(options: capDataStorageOptions): Promise<capDataStorageResult> {
    let ret: boolean;
    let key:string = options.key;
    if (key == null) {
      return Promise.reject("Must provide key");
    }
    ret = await this.mDb.iskey(key);
    return Promise.resolve({result:ret});
  }

  async keys(): Promise<capDataStorageResult> {
    let ret: Array<string>;
    ret = await this.mDb.keys();
    return Promise.resolve({keys:ret});
  }

  async values(): Promise<capDataStorageResult> {
    let ret: Array<string>;
    ret = await this.mDb.values();
    return Promise.resolve({values:ret});
  }

  async keysvalues(): Promise<capDataStorageResult> {
    let ret: Array<any> = [];
    let results: Array<Data>;
    results = await this.mDb.keysvalues();
    for (let i:number = 0;i<results.length;i++) {
      let res:any = {"key" : results[i].name, "value" : results[i].value};
      ret.push(res);
    }
    return Promise.resolve({keysvalues:ret});
  }
}

const CapacitorDataStorageSqlite = new CapacitorDataStorageSqliteWeb();

export { CapacitorDataStorageSqlite };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(CapacitorDataStorageSqlite);
