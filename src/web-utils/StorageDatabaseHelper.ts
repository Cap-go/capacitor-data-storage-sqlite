import LocalForage from 'localforage';
import { Data } from "../web-utils/data";

const DATABASE: string = "storageIDB";
const STORAGESTORE: string = "storage_store";
export class StorageDatabaseHelper {
    private _db: any;

    constructor() {
        let config: any= {
            name: DATABASE,
            storeName: STORAGESTORE,
            driver: LocalForage.INDEXEDDB,
            version: 1
          }
          this._db = LocalForage.createInstance(config);       
    }

    set(data:Data): Promise<boolean> {
        return this._db.setItem(data.name, data.value).then(()=> {
          return Promise.resolve(true);
        })
        .catch((error: string) => {
          console.log('set: Error Data insertion failed: ' + error);
          return Promise.resolve(false);
        });
    } 

    get(name: string): Promise<Data> {
        return this._db.getItem(name).then((value:string) => {
          return Promise.resolve(value);
        })
        .catch((error: string) => {
          console.log('get: Error Data retrieve failed: ' + error);
          return Promise.resolve(null);
        });
    }

    remove(name: string): Promise<boolean> {
        return this._db.removeItem(name).then(()=> {
          return Promise.resolve(true);
        })
        .catch((error: string) => {
          console.log('remove: Error Data remove failed: ' + error);
          return Promise.resolve(false);
        });
    }
    
    clear(): Promise<boolean> {
        return this._db.clear().then(()=> {
          return Promise.resolve(true);
        })
        .catch((error: string) => {
          console.log('clear: Error Data clear failed: ' + error);
          return Promise.resolve(false);
        });
    } 
    
    keys(): Promise<Array<string>> {
        return this._db.keys().then((keys:Array<string>) => {
            return Promise.resolve(keys)
        })
        .catch((error: string) => {
          console.log('keys: Error Data retrieve keys failed: ' + error);
          return Promise.resolve(null);
        });
    }

    values(): Promise<Array<string>> {
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

    keysvalues(): Promise<Array<Data>> {
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

    iskey(name:string):Promise<boolean> {
        return this.get(name).then((value)=> {
          if(value != null) {
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