# Capacitor Data Storage SQLite Plugin
Capacitor Data Storage SQlite  Plugin is a custom Native Capacitor plugin to store permanently data to SQLite on IOS and Android platforms and to IndexDB for the Web and Electron platforms.
As capacitor provides first-class Progressive Web App support so you can use this plugin in your app which will later be deployed to the app stores and the mobile web.

Capacitor Data Storage SQlite Plugin provides a key-value store for simple data of type string only, so JSON object can be stored, you should manage conversion through JSON.stringify before storing and JSON.parse when retrieving the data, use the same procedure for number through number.toString() and Number().


************************************************************
The -dev release should not be used for production releases
It is a complete re-write of the code to allow encrytion of
the storage sqlite database
It has been tested for Android and IOS
************************************************************


*******************************************************
Change since release 1.2.1-11
 - openStore method has been included to specify
    - the database name
    - the table name

   To be compatible with previous releases you must do:
   ```openStore()``` 

   To define new database and table name do:
   ```openStore({database:"MyDatabase",table:"MyTableName"})```

 - setTable method has been included to 
    - add a table to an existing opened store
    - set an already existing table to an existing opened store

    ```setTable({table:"MyNewTableName"})``` 



*******************************************************

## View Me
[capacitor-data-storage-sqlite](https://ionicpwacapacitorstorage.firebaseapp.com)

## Methods available

### `openStore({}) => Promise<{result:boolean}>`

Open the store with default database and table names

#### Returns

Type: `Promise<{result:boolean}>`

### `openStore({database:"fooDB",table:"fooTable"}) => Promise<{result:boolean}>`

Open the store with given database and table names

#### Returns

Type: `Promise<{result:boolean}>`

### `setTable({table:"foo1Table"}) => Promise<{result:boolean,message?: string}>`

Set or add a table to an already opened store

#### Returns

Type: `Promise<{result:boolean,message?: string}>`

### `set({key:"foo",value:"foovalue"}) => Promise<{result:boolean,message?: string}>`

Set a key and its value in the store

#### Returns

Type: `Promise<{result:boolean,message?: string}>`

### `get({key:"foo"}) => Promise<{value:string}>`

Get the value of a given key from the store

#### Returns

Type: `Promise<{value:string}>`

### `isKey({key:"foo"}) => Promise<{result:boolean}>`

Check if a given key exists in the store

#### Returns

Type: `Promise<{result:boolean}>`

### `keys() => Promise<{keys:Array<string>}>`

Get all keys from the store

#### Returns

Type: `Promise<{keys:Array<string>}>`

### `values() => Promise<{values:Array<string>}>`

Get all values from the store

#### Returns

Type: `Promise<{values:Array<string>}>`

### `keysvalues() => Promise<{keysvalues:Array<{key:string,value:string}>}>`

Get all key/value pairs from the store

#### Returns

Type: `Promise<{keysvalues:Array<{key:string,value:string}>}>`

### `remove({key:"foo"}) => Promise<{result:boolean}>`

Remove a key from the store

#### Returns

Type: `Promise<{result:boolean}>`

### `clear() => Promise<{result:boolean}>`

Clear / Remove all keys from the store

#### Returns

Type: `Promise<{result:boolean}>`


## Methods available for encrypted database in IOS and Android

### `openStore({database:"fooDB",table:"fooTable",encrypted:true,mode:"encryption"}) => Promise<{result:boolean}>`

Encrypt an existing store with a secret key and open the store with given database and table names. 
The secret key is set in the Global.swift file for IOS and in Global.java file for Android. Set your own before building your app.

#### Returns

Type: `Promise<{result:boolean}>`

### `openStore({database:"fooDB",table:"fooTable",encrypted:true,mode:"secret"}) => Promise<{result:boolean}>`

Open an encrypted store with given database and table names and secret key.
The secret key is set in the Global.swift file for IOS and in Global.java file for Android. Set your own before building your app.

#### Returns

Type: `Promise<{result:boolean}>`

### `openStore({database:"fooDB",table:"fooTable",encrypted:true,mode:"newsecret"}) => Promise<{result:boolean}>`

Modify the secret key with the newsecret key of an encrypted store and open it with given database and table names and newsecret key.
The secret key and newsecret key are set in the Global.swift file for IOS and in Global.java file for Android. Set your own before building your app.

#### Returns

Type: `Promise<{result:boolean}>`




## Using a wrapper to adhere to the Storage API 
(https://developer.mozilla.org/de/docs/Web/API/Storage)

 - Javascript wrapper

```javascript
export const StorageAPIWrapper = (storage:any) => {

    return {
      openStore: (options,cb) => {
          storage.openStore(options)
          .then(({result} ) => cb(null, result))
          .catch(cb);
      },
      setTable: (table, cb) => {
        storage.setTable(table)
        .then(({result,message} ) => cb(null, result,message))
        .catch(cb);
      },
      getAllKeys: cb => {
        storage.keys()
          .then(({ keys }) => cb(null, keys))
          .catch(cb);
      },
      getItem: (key, cb) => {
        storage.get({ key })
          .then(({ value }) => cb(null, value))
          .catch(cb);
      },
      setItem: (key, value, cb) => {
        storage.set({ key, value })
          .then(() => cb())
          .catch(cb);
      },
      removeItem: (key, cb) => {
        storage.remove({ key })
          .then(() => cb())
          .catch(cb);
      },
      clear: cb => {
        storage.clear()
          .then(() => cb())
          .catch(cb);
      },
    };
}

```
 - Typescript wrapper class

```typescript
import { Plugins } from '@capacitor/core';
import * as CapacitorSQLPlugin from 'capacitor-data-storage-sqlite';
const { CapacitorDataStorageSqlite, Device } = Plugins;

export class StorageAPIWrapper {
    public storage: any = {}
    constructor() { 
    }
    async init(): Promise<void> {
        const info = await Device.getInfo();
        console.log('platform ',info.platform)
        if (info.platform === "ios" || info.platform === "android") {
            this.storage = CapacitorDataStorageSqlite;
        }  else {
            this.storage = CapacitorSQLPlugin.CapacitorDataStorageSqlite;     
        } 
    }
    public async openStore(options:any): Promise<boolean> {
        await this.init();
        const {result} = await this.storage.openStore(options);
        return result;
    }
    public async setTable(table:any): Promise<any>  {
        const {result,message} = await this.storage.setTable(table);
        return Promise.resolve([result,message]);
    }
    public async setItem(key:string, value:string): Promise<void> {
        await this.storage.set({ key, value });
    return;
    }
    public async getItem(key:string): Promise<string> {
        const {value} = await this.storage.get({ key });
    return value;
    }
    public async getAllKeys(): Promise<Array<string>> {
        const {keys} = await this.storage.keys();
    return keys;
    }
    public async removeItem(key:string): Promise<void> {
        await this.storage.remove({ key });
    return;
    }
    public async clear(): Promise<void> {
        await this.storage.clear();
    return;
    }
}
```

and in your typescript app file

```typescript
  async testPluginWithWrapper() {
    this.storage = new StorageAPIWrapper();
    let ret1: boolean = false;
    let ret2: boolean = false;
    let ret3: boolean = false;
    let ret4: boolean = false;
    let ret5: boolean = false;
    let ret6: boolean = false;
    let result: boolean = await this.storage.openStore({});
    if(result){
      await this.storage.clear();
      await this.storage.setItem("key-test", "This is a test");
      let value:string = await this.storage.getItem("key-test")
      if (value === "This is a test") ret1 = true;
      let keys:Array<string> = await this.storage.getAllKeys();
      if (keys[0] === "key-test") ret2 = true;     
      await this.storage.removeItem("key-test");
      keys = await this.storage.getAllKeys();
      if (keys.length === 0) ret3 = true;           
      result = await this.storage.openStore({database:"testStore",table:"table1"});
      if(result) {
        await this.storage.clear();
        await this.storage.setItem("key1-test", "This is a new store");
        value = await this.storage.getItem("key1-test")
        if (value === "This is a new store") ret4 = true;
        let statusTable: any = await this.storage.setTable({table:"table2"});if(statusTable[0]) ret5 = true;
        await this.storage.clear();
        await this.storage.setItem("key2-test", "This is a second table");
        value = await this.storage.getItem("key2-test")
        if (value === "This is a second table") ret6 = true;
      }
    }
    if(ret1 && ret2 && ret3 && ret4 && ret5 && ret6) {
      console.log('testPlugin2 is successful');
    }
  }
```

## To use the Plugin in your Project
```bash
npm install --save capacitor-data-storage-sqlite@latest
```

Ionic App showing an integration of [capacitor-data-storage-sqlite plugin](https://github.com/jepiqueau/ionic-capacitor-data-storage-sqlite)

Vue App showing an integration of [capacitor-data-storage-sqlite plugin](https://github.com/jepiqueau/vue-capacitor-data-storage-sqlite)

PWA App showing an integration of 
[capacitor-data-storage-sqlite plugin](https://github.com/jepiqueau/ionicpwacapacitorstorage.git)


## Remarks
This release of the plugin includes the Native IOS code (Objective-C/Swift),the Native Android code (Java) and the Web code (Typescript) using Capacitor v1.4.0-dev.6

## Dependencies
The IOS  and Android codes are using SQLCipher allowing for database encryption, the Web code has been implemented with localforage  as wrapper for indexDB.


