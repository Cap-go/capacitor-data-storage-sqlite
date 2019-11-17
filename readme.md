# Capacitor Data Storage SQLite Plugin
Capacitor Data Storage SQlite  Plugin is a custom Native Capacitor plugin to store permanently data to SQLite on IOS and Android platforms and to IndexDB for the Web and Electron platforms.
As capacitor provides fisrt-class Progressive Web App support so you can use this plugin in your app which will later be deployed to the app stores and the mobile web.

Capacitor Data Storage SQlite Plugin provides a key-value store for simple data of type string only, so JSON object can be stored, you should manage conversion through JSON.stringify before storing and JSON.parse when retrieving the data, use the same procedure for number through number.toString() and Number().

*****************************************************************
WARNING !!!! NEVER USE RELEASES 1.2.1-5 to 1.2.1-8.
They are unsuccessful attemps of an Electron plugin using sqlite3
Will wait until the Ionic Capacitor Team provides a methodology
*****************************************************************


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

    clear()                                             clear the store
    openStore({})                                       open the store with default database and table names
    openStore({database:"fooDB",table:"fooTable"})      open the store with given database and table names
    setTable({table:"foo1Table"})                       set or add a table to the opened store
    get({key:"foo"})                                    get the value of a given key  
    iskey({key:"foo"})                                  test key exists
    keys()                                              get all keys
    keysvalues()                                        get all key/value pairs
    remove({key:"foo"})                                 remove a key
    set({key:"foo",value:"foovalue"})                   set key and its value
    values()                                            get all values

## Using a wrapper to adhere to the Storage API 
(https://developer.mozilla.org/de/docs/Web/API/Storage)

```javascript
export const createCapacitorSqliteStorage = (storage:any) => {

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

```typescript
export const wrapperToCapacitorSqliteStorage = (storage:any) => {

  return {
    openStore: async (options:any): Promise<boolean> => {
        const {result} = await storage.openStore(options);
        return result;
    },
    setTable: async (table:any): Promise<any> => {
      const {result,message} = await storage.setTable(table);
      return Promise.resolve([result,message])
    },
    setItem: async (key:string, value:string): Promise<void> => {
      await storage.set({ key, value });
      return;
    },
    getItem: async (key:string): Promise<string> => {
      const {value} = await storage.get({ key });
      return value;
    },
    getAllKeys: async (): Promise<Array<string>> => {
      const {keys} = await storage.keys();
      return keys;
    },
    removeItem: async (key:string): Promise<void> => {
      await storage.remove({ key });
      return;
    },
    clear: async (): Promise<void> => {
      await storage.clear();
      return;
    },

  }
}
```

and in your app file

```typescript
const info = await Device.getInfo();
let storage:any;
if (info.platform === "ios" || info.platform === "android") {
    storage = CapacitorDataStorageSqlite;
}  else {
    storage = CapacitorSQLPlugin.CapacitorDataStorageSqlite;     
}
    let result: boolean = await wrapperToCapacitorSqliteStorage(this.storage).openStore({});
    if(result){
      await wrapperToCapacitorSqliteStorage(this.storage).clear();
      await wrapperToCapacitorSqliteStorage(this.storage).setItem("key-test", "This is a test");
      let value:string = await wrapperToCapacitorSqliteStorage(this.storage).getItem("key-test")
      if (value === "This is a test") ret1 = true;
      let keys:Array<string> = await wrapperToCapacitorSqliteStorage(this.storage).getAllKeys();
      if (keys[0] === "key-test") ret2 = true;     
      await wrapperToCapacitorSqliteStorage(this.storage).removeItem("key-test");
      keys = await wrapperToCapacitorSqliteStorage(this.storage).getAllKeys();
      if (keys.length === 0) ret3 = true;           
      result = await wrapperToCapacitorSqliteStorage(this.storage).openStore({database:"testStore",table:"table1"});
      if(result) {
        await wrapperToCapacitorSqliteStorage(this.storage).clear();
        await wrapperToCapacitorSqliteStorage(this.storage).setItem("key1-test", "This is a new store");
        value = await wrapperToCapacitorSqliteStorage(this.storage).getItem("key1-test")
        if (value === "This is a new store") ret4 = true;
        let statusTable: any = await wrapperToCapacitorSqliteStorage(this.storage).setTable({table:"table2"}); 
        if(statusTable[0]) ret5 = true;
        await wrapperToCapacitorSqliteStorage(this.storage).clear();
        await wrapperToCapacitorSqliteStorage(this.storage).setItem("key2-test", "This is a second table");
        value = await wrapperToCapacitorSqliteStorage(this.storage).getItem("key2-test")
        if (value === "This is a second table") ret6 = true;
      }
    }
    if(ret1 && ret2 && ret3 && ret4 && ret5 && ret6) {
      console.log('testPlugin2 is successful')
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
This release of the plugin includes the Native IOS code (Objective-C/Swift),the Native Android code (Java) and the Web code (Typescript) using Capacitor v1.2.1

## Dependencies
The IOS code is based on SQLite.swift as wrapper for SQLite, the Web code has been implemented with localforage  as wrapper for indexDB.


