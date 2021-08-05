//import LocalForage from 'jeep-localforage';
import localForage from 'localforage';

import { Data } from './Data';

//const DATABASE: string = "storageIDB";
//const STORAGESTORE: string = "storage_store";
export class StorageDatabaseHelper {
  private _db: any = null;
  private _dbName: string;

  constructor(dbName: string, tableName: string) {
    const res: boolean = this.openStore(dbName, tableName);
    if (res) {
      this._dbName = dbName;
    } else {
      this._dbName = '';
      throw new Error('openStore return false');
    }
  }
  openStore(dbName: string, tableName: string): boolean {
    let ret = false;
    const config: any = this.setConfig(dbName, tableName);
    this._db = localForage.createInstance(config);
    if (this._db != null) {
      this._dbName = dbName;
      ret = true;
    }
    return ret;
  }
  setConfig(dbName: string, tableName: string): any {
    const config: any = {
      name: dbName,
      storeName: tableName,
      driver: [localForage.INDEXEDDB, localForage.WEBSQL],
      version: 1,
    };
    return config;
  }
  async setTable(tableName: string): Promise<void> {
    const res: boolean = this.openStore(this._dbName, tableName);
    if (res) {
      return Promise.resolve();
    } else {
      return Promise.reject(new Error('openStore return false'));
    }
  }
  async set(data: Data): Promise<void> {
    try {
      await this._db.setItem(data.name, data.value);
      return Promise.resolve();
    } catch (err) {
      return Promise.reject(err);
    }
  }

  async get(name: string): Promise<Data> {
    try {
      const value: string = await this._db.getItem(name);
      const data: Data = new Data();
      data.name = name;
      data.value = value;
      return Promise.resolve(data);
    } catch (err) {
      return Promise.reject(err);
    }
  }

  async remove(name: string): Promise<void> {
    return this._db
      .removeItem(name)
      .then(() => {
        return Promise.resolve();
      })
      .catch((error: string) => {
        return Promise.reject(error);
      });
  }

  async clear(): Promise<void> {
    return this._db
      .clear()
      .then(() => {
        return Promise.resolve();
      })
      .catch((error: string) => {
        return Promise.reject(error);
      });
  }

  async keys(): Promise<string[]> {
    return this._db
      .keys()
      .then((keys: string[]) => {
        return Promise.resolve(keys);
      })
      .catch((error: string) => {
        return Promise.reject(error);
      });
  }

  async values(): Promise<string[]> {
    const values: string[] = [];
    return this._db
      .iterate((value: string) => {
        values.push(value);
      })
      .then(() => {
        return Promise.resolve(values);
      })
      .catch((error: string) => {
        return Promise.reject(error);
      });
  }

  async keysvalues(): Promise<Data[]> {
    const keysvalues: Data[] = [];
    return this._db
      .iterate((value: string, key: string) => {
        const data: Data = new Data();
        data.name = key;
        data.value = value;
        keysvalues.push(data);
      })
      .then(() => {
        return Promise.resolve(keysvalues);
      })
      .catch((error: string) => {
        return Promise.reject(error);
      });
  }

  async iskey(name: string): Promise<boolean> {
    return this.get(name)
      .then(data => {
        if (data.value != null) {
          return Promise.resolve(true);
        } else {
          return Promise.resolve(false);
        }
      })
      .catch((error: string) => {
        return Promise.reject(error);
      });
  }
}
