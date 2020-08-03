<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h3 align="center">DATA STORAGE SQLITE</h3>
<p align="center"><strong><code>capacitor-data-storage-sqlite</code></strong></p>
<p align="center">
  Capacitor Data Storage SQlite Plugin is a custom Native Capacitor plugin providing a key-value permanent store for simple data of <strong>type string only</strong> to SQLite on IOS, Android and Electron platforms and to IndexDB for the Web platform.</p>

<p align="center">
  <img src="https://img.shields.io/maintenance/yes/2020?style=flat-square" />
  <a href="https://github.com/jepiqueau/capacitor-data-storage-sqlite/actions?query=workflow%3A%22CI%22"><img src="https://img.shields.io/github/workflow/status/jepiqueau/capacitor-data-storage-sqlite/CI?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/jepiqueau/capacitor-data-storage-sqlite"><img src="https://img.shields.io/npm/l/@capacitor-community/sqlite?style=flat-square" /></a>
<br>
  <a href="https://www.npmjs.com/package/jepiqueau/capacitor-data-storage-sqlite"><img src="https://img.shields.io/npm/dw/@capacitor-community/sqlite?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/jepiqueau/capacitor-data-storage-sqlite"><img src="https://img.shields.io/npm/v/@capacitor-community/sqlite?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
<a href="#contributors-"><img src="https://img.shields.io/badge/all%20contributors-1-orange?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:END -->
</p>

## Maintainers

| Maintainer        | GitHub                                    | Social |
| ----------------- | ----------------------------------------- | ------ |
| Quéau Jean Pierre | [jepiqueau](https://github.com/jepiqueau) |        |

## Installation

```bash
npm install capacitor-data-storage-sqlite
npx cap sync
```

- On iOS, no further steps are needed.

- On Android, register the plugin in your main activity:

  ```java
  import com.jeep.plugin.capacitor.CapacitorDataStorageSqlite;

  public class MainActivity extends BridgeActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);

      // Initializes the Bridge
      this.init(
          savedInstanceState,
          new ArrayList<Class<? extends Plugin>>() {

            {
              // Additional plugins you've installed go here
              // Ex: add(TotallyAwesomePlugin.class);
              add(CapacitorDataStorageSqlite.class);
            }
          }
        );
    }
  }
  ```

- On Electron, go to the Electron folder of YOUR_APPLICATION

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
        if (
          process &&
          typeof process.versions.electron === 'string' &&
          process.versions.hasOwnProperty('electron')
        ) {
          const sqlite3 = require('sqlite3');
          const fs = require('fs');
          const path = require('path');
          window.sqlite3 = sqlite3;
          window.fs = fs;
          window.path = path;
        }
      } catch {
        console.log("process doesn't exists");
      }
    </script>
  </body>
  ```

The datastores created are under **YourApplication/Electron/DataStorage**

Then build YOUR_APPLICATION

```
npm run build
npx cap copy
npx cap copy web
npx cap open android
npx cap open ios
npx cap open electron
npx cap serve
```

## Configuration

No configuration required for this plugin

## Supported methods

| Name                         | Android | iOS | Electron | Web |
| :--------------------------- | :------ | :-- | :------- | :-- |
| openStore (non-encrypted DB) | ✅      | ✅  | ✅       | ✅  |
| openStore (encrypted DB)     | ✅      | ✅  | ❌       | ❌  |
| setTable                     | ✅      | ✅  | ✅       | ✅  |
| set                          | ✅      | ✅  | ✅       | ✅  |
| get                          | ✅      | ✅  | ✅       | ✅  |
| iskey                        | ✅      | ✅  | ✅       | ✅  |
| keys                         | ✅      | ✅  | ✅       | ✅  |
| values                       | ✅      | ✅  | ✅       | ✅  |
| keysvalues                   | ✅      | ✅  | ✅       | ✅  |
| remove                       | ✅      | ✅  | ✅       | ✅  |
| clear                        | ✅      | ✅  | ✅       | ✅  |
| deleteStore                  | ✅      | ✅  | ✅       | ❌  |

## Documentation

[API_Documentation](https://github.com/jepiqueau/capacitor-data-storage-sqlite/blob/master/docs/APIdocumentation.md)

## Applications demonstrating the use of the plugin

### Ionic/Angular

- [data-storage-sqlite-app-starter](https://github.com/jepiqueau/angular-data-storage-sqlite-app-starter)

- [test-angular-jeep-capacitor-plugins](https://github.com/jepiqueau/capacitor-apps/tree/master/IonicAngular/jeep-test-app)

### Ionic/React

### React

- [react-datastoragesqlite-app](https://github.com/jepiqueau/react-datastoragesqlite-app)

## Usage

- [see capacitor documentation](https://capacitor.ionicframework.com/docs/getting-started/with-ionic)

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

````

## Usage on PWA

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
````

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
export const StorageAPIWrapper = (storage: any) => {
  return {
    openStore: (options, cb) => {
      storage
        .openStore(options)
        .then(({ result }) => cb(null, result))
        .catch(cb);
    },
    setTable: (table, cb) => {
      storage
        .setTable(table)
        .then(({ result, message }) => cb(null, result, message))
        .catch(cb);
    },
    getAllKeys: cb => {
      storage
        .keys()
        .then(({ keys }) => cb(null, keys))
        .catch(cb);
    },
    getItem: (key, cb) => {
      storage
        .get({ key })
        .then(({ value }) => cb(null, value))
        .catch(cb);
    },
    setItem: (key, value, cb) => {
      storage
        .set({ key, value })
        .then(() => cb())
        .catch(cb);
    },
    removeItem: (key, cb) => {
      storage
        .remove({ key })
        .then(() => cb())
        .catch(cb);
    },
    clear: cb => {
      storage
        .clear()
        .then(() => cb())
        .catch(cb);
    },
    deleteStore: (options, cb) => {
      storage
        .deleteStore(options)
        .then(({ result }) => cb(null, result))
        .catch(cb);
    },
  };
};
```

- Typescript wrapper class

```typescript
import { Plugins } from '@capacitor/core';
import * as CapacitorSQLPlugin from 'capacitor-data-storage-sqlite';
const { CapacitorDataStorageSqlite, Device } = Plugins;

export class StorageAPIWrapper {
  public storage: any = {};
  constructor() {}
  async init(): Promise<void> {
    const info = await Device.getInfo();
    console.log('platform ', info.platform);
    if (info.platform === 'ios' || info.platform === 'android') {
      this.storage = CapacitorDataStorageSqlite;
    } else {
      this.storage = CapacitorSQLPlugin.CapacitorDataStorageSqlite;
    }
  }
  public async openStore(options: any): Promise<boolean> {
    await this.init();
    const { result } = await this.storage.openStore(options);
    return result;
  }
  public async setTable(table: any): Promise<any> {
    const { result, message } = await this.storage.setTable(table);
    return Promise.resolve([result, message]);
  }
  public async setItem(key: string, value: string): Promise<void> {
    await this.storage.set({ key, value });
    return;
  }
  public async getItem(key: string): Promise<string> {
    const { value } = await this.storage.get({ key });
    return value;
  }
  public async getAllKeys(): Promise<Array<string>> {
    const { keys } = await this.storage.keys();
    return keys;
  }
  public async removeItem(key: string): Promise<void> {
    await this.storage.remove({ key });
    return;
  }
  public async clear(): Promise<void> {
    await this.storage.clear();
    return;
  }
  public async deleteStore(options: any): Promise<boolean> {
    await this.init();
    const { result } = await this.storage.deleteStore(options);
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

The IOS and Android codes are using SQLCipher allowing for database encryption. The Electron code use sqlite3.
The Web code has been implemented with localforage as wrapper for indexDB.
