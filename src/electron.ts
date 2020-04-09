import { WebPlugin } from '@capacitor/core';
import { StorageDatabaseHelper } from './electron-utils/StorageDatabaseHelper';
import { Data } from './electron-utils/Data';
import { CapacitorDataStorageSqlitePlugin, capDataStorageOptions, capDataStorageResult , capOpenStorageOptions } from './definitions';

export class CapacitorDataStorageSqlitePluginElectron extends WebPlugin implements CapacitorDataStorageSqlitePlugin {
    mDb:StorageDatabaseHelper;
    constructor() {
      super({
        name: 'CapacitorDataStorageSqlite',
        platforms: ['electron']
      });
      this.mDb = new StorageDatabaseHelper();
    }
    async echo(options: { value: string }): Promise<{value: string}> {
        console.log('ECHO in Electron Plugin', options);
        return options;
    }
    async openStore(options: capOpenStorageOptions): Promise<capDataStorageResult> {
        let ret: boolean = false;
        let dbName = options.database ? `${options.database}SQLite.db` : "storageSQLite.db";
        let tableName = options.table ? options.table : "storage_store";
        ret = await this.mDb.openStore(dbName,tableName);
        return Promise.resolve({result:ret});
    }
    
      async setTable(options: capOpenStorageOptions): Promise<capDataStorageResult> {
        let tableName = options.table;
        if (tableName == null) {
          return Promise.reject({result:false,message:"Must provide a table name"});
        }
        let ret: boolean = false;
        let message: string = "";
        if(this.mDb) {
          ret = await this.mDb.setTable(tableName);
          if (ret) {
            return Promise.resolve({result:ret, message:message});
          } else {
            return Promise.reject({result:ret, message:"failed in adding table"});
          }
        } else {
          return Promise.reject({result:ret, message:"Must open a store first"});
        }
      }
    
    async set(options: capDataStorageOptions): Promise<capDataStorageResult> {
        let ret: boolean;
        let key:string = options.key;
        if (key == null) {
          return Promise.reject({result:false,message:"Must provide key"});
        }
        let value: string = options.value;
        if (value == null) {
          return Promise.reject({result:false,message:"Must provide value"});
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
          return Promise.reject({result:false,message:"Must provide key"});
        }
        let data: Data = await this.mDb.get(key);
        ret = data != null && data.id != null ? data.value : null;
        return Promise.resolve({value: ret});
    }
    
    async remove(options: capDataStorageOptions): Promise<capDataStorageResult> {
        let ret: boolean;
        let key:string = options.key;
        if (key == null) {
          return Promise.reject({result:false,message:"Must provide key"});
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
          return Promise.reject({result:false,message:"Must provide key"});
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
    async deleteStore(options: capOpenStorageOptions): Promise<capDataStorageResult> {
        let dbName = options.database
        if (dbName == null) {
          return Promise.reject({result:false,message:"Must provide a Database Name"});
        }
        dbName = `${options.database}SQLite.db`;
        if(typeof this.mDb === 'undefined' || this.mDb === null) this.mDb = new StorageDatabaseHelper();
        const ret = await this.mDb.deleteStore(dbName);
        this.mDb = null;
        return Promise.resolve({result:ret});
    }
       
} 
const CapacitorDataStorageSqliteElectron = new CapacitorDataStorageSqlitePluginElectron();

export { CapacitorDataStorageSqliteElectron }; 
import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(CapacitorDataStorageSqliteElectron);
