# Capacitor Data Storage SQLite Plugin
Capacitor Data Storage SQlite  Plugin is a custom Native Capacitor plugin to store permanently data to SQLite on IOS, Android and Electron platforms and to IndexDB for the Web platform.

Capacitor Data Storage SQlite Plugin provides a key-value store for simple data of `**type string only**`, so JSON object can be stored, you should manage conversion through JSON.stringify before storing and JSON.parse when retrieving the data, use the same procedure for number through number.toString() and Number().

For both IOS and Android platforms, the store can be encrypted. The plugin uses SQLCipher for encryption with a `**passphrase**`.

## Methods available

### `openStore({}) => Promise<{result:boolean}>`

Open the store with default database and table names

#### Returns

Type: `Promise<{result:boolean}>`

### `openStore({database:"fooDB",table:"fooTable"}) => Promise<{result:boolean}>`

Open the store with given database and table names
the plugin add a suffix "SQLite" and an extension ".db" to the name given ie (fooDBSQLite.db)


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

### `iskey({key:"foo"}) => Promise<{result:boolean}>`

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

## Methods available only for IOS and Android Plugins


### `deleteStore({}) => Promise<{result:boolean}>`

Delete the store with default database name

#### Returns

Type: `Promise<{result:boolean}>`

### `deleteStore({database:"fooDB"}) => Promise<{result:boolean}>`

Delete the store with given database name

#### Returns

Type: `Promise<{result:boolean}>`


## Methods available for encrypted database in IOS and Android

### `openStore({database:"fooDB",table:"fooTable",encrypted:true,mode:"encryption"}) => Promise<{result:boolean}>`

Encrypt an existing store with a secret key and open the store with given database and table names.

To define your own "secret" and "newsecret" keys: 
 - in IOS, go to the Pod/Development Pods/jeepqCapacitor/DataStorageSQLite/Global.swift file 
 - in Android, go to jeepq-capacitor/java/com.jeep.plugins.capacitor/cdssUtils/Global.java
and update the default values before building your app.

#### Returns

Type: `Promise<{result:boolean}>`

### `openStore({database:"fooDB",table:"fooTable",encrypted:true,mode:"secret"}) => Promise<{result:boolean}>`

Open an encrypted store with given database and table names and secret key.

#### Returns

Type: `Promise<{result:boolean}>`

### `openStore({database:"fooDB",table:"fooTable",encrypted:true,mode:"newsecret"}) => Promise<{result:boolean}>`

Modify the secret key with the newsecret key of an encrypted store and open it with given database and table names and newsecret key.

#### Returns

Type: `Promise<{result:boolean}>`

## Applications demonstrating the use of the plugin

### Ionic/Angular
  - [data-storage-sqlite-app-starter] (https://github.com/jepiqueau/angular-data-storage-sqlite-app-starter)

  - [test-angular-jeep-capacitor-plugins] (https://github.com/jepiqueau/capacitor-apps/tree/master/IonicAngular/jeep-test-app)

### Ionic/React

### React
  - [react-datastoragesqlite-app] (https://github.com/jepiqueau/react-datastoragesqlite-app)

  
## Using the Plugin in your App

 - [see capacitor documentation](https://capacitor.ionicframework.com/docs/getting-started/with-ionic)

 - Plugin installation

  ```bash
  npm install --save capacitor-data-storage-sqlite@latest
  ```
 - In your code

 ```ts
  import { Plugins } from '@capacitor/core';
  import * as CDSSPlugin from 'capacitor-data-storage-sqlite';
  const { CapacitorDataStorageSqlite,Device } = Plugins;

  @Component( ... )
  export class MyPage {
    _storage: any;

    ...

    async ngAfterViewInit()() {
      const info = await Device.getInfo();
      if (info.platform === "ios" || info.platform === "android") {
        this._storage = CapacitorDataStorageSqlite;
      } else if(this.platform === "electron") {
        this.store = CDSSPlugin.CapacitorDataStorageSqliteElectron;
      } else {
        this._storage = CDSSPlugin.CapacitorDataStorageSqlite
      }

    }

    async testStoragePlugin() {
      const result:any = await this._storage.openStore({});
      if (result.result) {
        let ret:any;
        ret = await this._storage.set({key:"session",value:"Session Opened"});
        console.log("Save Data : " + ret.result);
        ret = await this._storage.get({key:"session"})
        console.log("Get Data : " + ret.value);

        ...
      }
    }
    ...
  }
 ```
### Running on Android

 ```bash
 npx cap update
 npm run build
 npx cap copy
 npx cap open android
 ``` 
 Android Studio will be opened with your project and will sync the files.
 In Android Studio go to the file MainActivity

 ```java 
  ...
 import com.jeep.plugin.capacitor.CapacitorDataStorageSqlite;

  ...

  public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);

      // Initializes the Bridge
      this.init(savedInstanceState, new ArrayList<Class<? extends Plugin>>() {{
        // Additional plugins you've installed go here
        // Ex: add(TotallyAwesomePlugin.class);
        add(CapacitorDataStorageSqlite.class);
      }});
    }
  }
 ``` 
### Running on IOS

 Modify the Podfile under the ios folder as follows

 ```
 platform :ios, '11.0'
 use_frameworks!

 # workaround to avoid Xcode 10 caching of Pods that requires
 # Product -> Clean Build Folder after new Cordova plugins installed
 # Requires CocoaPods 1.6 or newer
 install! 'cocoapods', :disable_input_output_paths => true

 def capacitor_pods
  # Automatic Capacitor Pod dependencies, do not delete
  pod 'Capacitor', :path => '../../node_modules/@capacitor/ios'
  pod 'CapacitorCordova', :path => '../../node_modules/@capacitor/ios'
  pod 'CapacitorDataStorageSqlite', :path => '../../node_modules/capacitor-data-storage-sqlite'
 # Do not delete
 end

 target 'App' do
  capacitor_pods
  # Add your Pods here
 end
 ```

 ```bash
 npx cap update
 npm run build
 npx cap copy
 npx cap open ios
 ```

### Running on Electron

In your application folder add the Electron platform

```bash
npx cap add electron
```

In the Electron folder of your application

```bash
npm install --save sqlite3
npm install --save-dev @types/sqlite3
npm install --save-dev electron-rebuild
```

Modify the Electron package.json file by adding a script "postinstall"

```json
  "scripts": {
    "electron:start": "electron ./",
    "postinstall": "electron-rebuild -f -w sqlite3"
  },
```

Execute the postinstall script

```bash
npm run postinstall
```
Go back in the main folder of your application
Add a script in the index.html file of your application in the body tag

```html
<body>
  <app-root></app-root>
  <script>
    try {
      if (process && typeof (process.versions.electron) === 'string' && process.versions.hasOwnProperty('electron')) {
        const sqlite3 = require('sqlite3');
        const fs = require('fs');
        const path = require('path');
        window.sqlite3 = sqlite3;
        window.fs = fs;
        window.path = path;
      }
    }
    catch {
      console.log("process doesn't exists");
    }
  </script>
</body>
```
and then build the application

```bash
 npx cap update
 npm run build
 npx cap copy
 npx cap open electron
```

The datastores created are under **YourApplication/Electron/DataStorage**


### Running on PWA

 - in your code
 ```ts
 import {  CapacitorDataStorageSqlite } from 'capacitor-data-storage-sqlite';
  @Component( ... )
  export class MyApp {
    componentDidLoad() {
    const storage: any = CapacitorDataStorageSqlite;
    // Open the Store
    let resOpen:any = await storage.openStore({});
    if(resOpen) {
      // Store Data
      let result:any = await storage.set({key:"session", value:"Session Opened"});
      console.log("Save Data : " + result.result);
      // Retrieve Data
      result = await storage.get({key:"session"})
      console.log("Get Data : " + result.value);
    }
  }
 ```

 ```bash
 npm run build
 npx cap copy
 npx cap copy web
 npm start
 ``` 

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
      deleteStore: (options,cb) => {
        storage.deleteStore(options)
          .then(({result} ) => cb(null, result))
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
    public async deleteStore(options:any): Promise<boolean> {
        await this.init();
        const {result} = await this.storage.deleteStore(options);
        return result;
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

## Dependencies
The IOS  and Android codes are using SQLCipher allowing for database encryption, the Web code has been implemented with localforage  as wrapper for indexDB.

