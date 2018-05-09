import { Plugins, WebPlugin, WebPlugins, mergeWebPlugin } from '@capacitor/core';
import { StorageDatabaseHelper } from './web-utils/StorageDatabaseHelper';
import { Data } from './web-utils/data';
import { CapacitorDataStorageSqlitePlugin } from './definitions';

export class CapacitorDataStorageIdbWeb extends WebPlugin implements CapacitorDataStorageSqlitePlugin {
  // as we are on the web the store will be on indexDB and not on SQLite
  mDb:StorageDatabaseHelper;
  
  constructor() {
    super({
      name: 'CapacitorDataStorageSqlite',
      platforms: ['web']
    });
    let p: WebPlugin = WebPlugins.getPlugin('CapacitorDataStorageSqlite');
    console.log('WebPlugin ',p);
    this.mDb = new StorageDatabaseHelper();
  }

  async set(options: { key: string, value: string }): Promise<{result: boolean}> {
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

  async get(options: { key: string}): Promise<{value: string }> {
    let ret:  string;
    let key:string = options.key;
    if (key == null) {
      return Promise.reject("Must provide key");
    }
    let data: Data = await this.mDb.get(key);
    ret = data != null ? data.value : null;
    return Promise.resolve({value: ret});
  }

  async remove(options: {key:string}): Promise<{result: boolean}> {
    let ret: boolean;
    let key:string = options.key;
    if (key == null) {
      return Promise.reject("Must provide key");
    }
    ret = await this.mDb.remove(key);
    return Promise.resolve({result:ret});
  }

  async clear(): Promise<{result: boolean}> {
    let ret: boolean;
    ret = await this.mDb.clear();
    return Promise.resolve({result:ret});
  }

  async iskey(options: {key:string}): Promise<{result: boolean}> {
    let ret: boolean;
    let key:string = options.key;
    if (key == null) {
      return Promise.reject("Must provide key");
    }
    ret = await this.mDb.iskey(key);
    return Promise.resolve({result:ret});
  }

  async keys(): Promise<{keys: Array<string>}> {
    let ret: Array<string>;
    ret = await this.mDb.keys();
    return Promise.resolve({keys:ret});
  }

  async values(): Promise<{values: Array<string>}> {
    let ret: Array<string>;
    ret = await this.mDb.values();
    return Promise.resolve({values:ret});
  }

  async keysvalues(): Promise<{keysvalues: Array<any>}> {
    let ret: Array<any>;
    ret = await this.mDb.keysvalues();
    return Promise.resolve({keysvalues:ret});
  }
}

const CapacitorDataStorageSqlite = new CapacitorDataStorageIdbWeb();
mergeWebPlugin(Plugins,CapacitorDataStorageSqlite);
export { CapacitorDataStorageSqlite };
