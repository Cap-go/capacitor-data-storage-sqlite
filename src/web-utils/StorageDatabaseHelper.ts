import LocalForage from 'jeep-localforage';
import { Data } from "./Data";

//const DATABASE: string = "storageIDB";
//const STORAGESTORE: string = "storage_store";
export class StorageDatabaseHelper {
    private _db: any = null;
    private _dbName: string;
 
    constructor(dbName: string, tableName: string) {
      this.openStore(dbName, tableName);
    }
    openStore(dbName: string, tableName: string) : boolean {
      let ret:boolean = false;
      const config: any = this.setConfig(dbName, tableName)
      this._db = LocalForage.createInstance(config); 
      if(this._db != null) {
        this._dbName = dbName;
        ret = true;
      } 
      return ret;    
    }
    setConfig(dbName: string, tableName: string): any {
      let config: any= {
        name: dbName,
        storeName: tableName,
        driver: [LocalForage.INDEXEDDB,LocalForage.WEBSQL],
        version: 1
      };
      return config;
    }
    async setTable(tableName: string) : Promise<boolean> {
      return this.openStore(this._dbName, tableName);
    }
    async set(data:Data): Promise<boolean> {
        return this._db.setItem(data.name, data.value).then(()=> {
          return Promise.resolve(true);
        })
        .catch((error: string) => {
          console.log('set: Error Data insertion failed: ' + error);
          return Promise.resolve(false);
        });
    } 

    async get(name: string): Promise<Data> {
        return this._db.getItem(name).then((value:string) => {
          let data: Data = new Data();
          data.name = name;
          data.value = value;
          return Promise.resolve(data);
        })
        .catch((error: string) => {
          console.log('get: Error Data retrieve failed: ' + error);
          return Promise.resolve(null);
        });
    }

    async remove(name: string): Promise<boolean> {
        return this._db.removeItem(name).then(()=> {
          return Promise.resolve(true);
        })
        .catch((error: string) => {
          console.log('remove: Error Data remove failed: ' + error);
          return Promise.resolve(false);
        });
    }
    
    async clear(): Promise<boolean> {
        return this._db.clear().then(()=> {
          return Promise.resolve(true);
        })
        .catch((error: string) => {
          console.log('clear: Error Data clear failed: ' + error);
          return Promise.resolve(false);
        });
    } 
    
    async keys(): Promise<Array<string>> {
        return this._db.keys().then((keys:Array<string>) => {
            return Promise.resolve(keys)
        })
        .catch((error: string) => {
          console.log('keys: Error Data retrieve keys failed: ' + error);
          return Promise.resolve(null);
        });
    }

    async values(): Promise<Array<string>> {
        let values: Array<string> = [];
        return this._db.iterate(((value:string) => {
          values.push(value);
        })).then(() => {
            return Promise.resolve(values)
        })
        .catch((error: string) => {
          console.log('values: Error Data retrieve values failed: ' + error);
          return Promise.resolve(null);
        });
    } 

    async keysvalues(): Promise<Array<Data>> {
        let keysvalues: Array<Data> = [];
        return this._db.iterate(((value:string, key:string) => {
          let data: Data = new Data();
          data.name = key;
          data.value = value; 
          keysvalues.push(data);
        })).then(() => {
            return Promise.resolve(keysvalues)
        })
        .catch((error: string) => {
          console.log('keysvalues: Error Data retrieve keys/values failed: ' + error);
          return Promise.resolve(null);
        });
    } 

    async iskey(name:string):Promise<boolean> {
        return this.get(name).then((data)=> {
          if(data.value != null) {
            return Promise.resolve(true);
          } else {
            return Promise.resolve(false); 
          }
        })
        .catch((error: string) => {
          console.log('iskey: Error Data retrieve iskey failed: ' + error);
          return Promise.resolve(false);
        });
    }
        
}