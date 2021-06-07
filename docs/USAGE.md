<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h2 align="center">USAGE DOCUMENTATION</h2>
<p align="center"><strong><code>capacitor-data-storage-sqlite</code></strong></p>
<br>
<p align="center" style="font-size:50px;color:red"><strong>CAPACITOR 3 🚧</strong></p><br>
<p align="center">
  iOS for testing only</p>
<p align="center">
  Capacitor Data Storage SQlite Plugin can be used in several frameworks, either through its own API or through Wrappers or Hooks.</p>

## Frameworks Index

- [`Ionic/Angular`](#ionicangular)

## Usage

### Ionic/Angular

- define a service

```ts
import { Injectable } from '@angular/core';

import { Capacitor } from '@capacitor/core';
import { CapacitorDataStorageSqlite,} from 'capacitor-data-storage-sqlite';

@Injectable({
  providedIn: 'root'
})
export class StoreService {
  store: any;
  isService: boolean = false;
  platform: string;
  constructor() {
  }
  /**
   * Plugin Initialization
   */
  async init(): Promise<void> {
    this.platform = Capacitor.getPlatform();
    this.store = CapacitorDataStorageSqlite;
    this.isService = true;
    console.log('in init ',this.platform,this.isService)
  }
  /**
   * Open a Store
   * @param _dbName string optional
   * @param _table string optional
   * @param _encrypted boolean optional 
   * @param _mode string optional
   */  
  async openStore(_dbName?:string,_table?:string,_encrypted?:boolean,_mode?:string): Promise<void> {
    if(this.isService && this.store != null) {
      const database: string = _dbName ? _dbName : "storage";
      const table: string = _table ? _table : "storage_table";
      const encrypted:boolean = _encrypted ? _encrypted : false;
      const mode: string = _mode ? _mode : "no-encryption";
      try {
        await this.store.openStore({database,table,encrypted,mode});
        return Promise.resolve();
      } catch (err) {
        return Promise.reject(err);
      }      
    } else {
      return Promise.reject(new Error("openStore: Store not opened"));
    }
  }
  /**
   * Close a store
   * @param dbName 
   * @returns 
   */
  async closeStore(dbName: String): Promise<void> {
    if(this.isService && this.store != null) {
      try {
        await this.store.closeStore({database:dbName});
        return Promise.resolve();
      } catch (err) {
        return Promise.reject(err);
      }      
    } else {
      return Promise.reject(new Error("close: Store not opened"));
    }
  }
  /**
   * Check if a store is opened
   * @param dbName 
   * @returns 
   */
  async isStoreOpen(dbName: String): Promise<void> {
    if(this.isService && this.store != null) {
      try {
        const ret = await this.store.isStoreOpen({database:dbName});
        return Promise.resolve(ret);
      } catch (err) {
        return Promise.reject(err);
      }      
    } else {
      return Promise.reject(new Error("isStoreOpen: Store not opened"));
    }
  }
  /**
   * Check if a store already exists
   * @param dbName
   * @returns 
   */
  async isStoreExists(dbName: String): Promise<void> {
    if(this.isService && this.store != null) {
      try {
        const ret = await this.store.isStoreExists({database:dbName});
        return Promise.resolve(ret);
      } catch (err) {
        return Promise.reject(err);
      }      
    } else {
      return Promise.reject(new Error("isStoreExists: Store not opened"));
    }
  }
  /**
   * Create/Set a Table
   * @param table string
   */  
  async setTable(table:string): Promise<void> {
    if(this.isService && this.store != null) {
      try {
        await this.store.setTable({table});
        return Promise.resolve();
      } catch (err) {
        return Promise.reject(err);
      }      
    } else {
      return Promise.reject(new Error("setTable: Store not opened"));
    }
  }
  /**
   * Set of Key
   * @param key string 
   * @param value string
   */
  async setItem(key:string,value:string): Promise<void> {
    if(this.isService && this.store != null) {
      if(key.length > 0) {
        try {
          await this.store.set({ key, value });
          return Promise.resolve();
        } catch (err) {
          return Promise.reject(err);
        }      
      } else {
        return Promise.reject(new Error("setItem: Must give a key"));
      }
    } else {
      return Promise.reject(new Error("setItem: Store not opened"));
    }
  }
  /**
   * Get the Value for a given Key
   * @param key string 
   */
  async getItem(key:string): Promise<string> {
    if(this.isService && this.store != null) {
      if(key.length > 0) {
        try {
          const {value} = await this.store.get({ key });
          console.log("in getItem value ",value)
          return Promise.resolve(value);
        } catch (err) {
          console.log(`$$$$$ in getItem key: ${key} err: ${JSON.stringify(err)}`)
          return Promise.reject(err);
        }      
      } else {
        return Promise.reject(new Error("getItem: Must give a key"));
      }
    } else {
      return Promise.reject(new Error("getItem: Store not opened"));
    }

  }
  async isKey(key:string): Promise<boolean> {
    if(this.isService && this.store != null) {
      if(key.length > 0) {
        try {
          const {result} = await this.store.iskey({ key });
          return Promise.resolve(result);
        } catch (err) {
          return Promise.reject(err);
        }
      } else {
        return Promise.reject(new Error("isKey: Must give a key"));
      }
    } else {
      return Promise.reject(new Error("isKey: Store not opened"));
    }

  }

  async getAllKeys(): Promise<Array<string>> {
    if(this.isService && this.store != null) {
      try {
        const {keys} = await this.store.keys();
        return Promise.resolve(keys); 
      } catch (err) {
        return Promise.reject(err);
      }
    } else {
      return Promise.reject(new Error("getAllKeys: Store not opened"));
    }
  }
  async getAllValues(): Promise<Array<string>> {
    if(this.isService && this.store != null) {
      try {
        const {values} = await this.store.values();
        return Promise.resolve(values);
      } catch (err) {
        return Promise.reject(err);
      }
    } else {
      return Promise.reject(new Error("getAllValues: Store not opened"));
    }
  }
  async getFilterValues(filter:string): Promise<Array<string>> {
    if(this.isService && this.store != null) {
      try {
        const {values} = await this.store.filtervalues({ filter });
        return Promise.resolve(values);
      } catch (err) {
        return Promise.reject(err);
      }
    } else {
      return Promise.reject(new Error("getFilterValues: Store not opened"));
    }
  }
  async getAllKeysValues(): Promise<Array<any>> {
    if(this.isService && this.store != null) {
      try {
        const {keysvalues} = await this.store.keysvalues();
        return Promise.resolve(keysvalues);
      } catch (err) {
        return Promise.reject(err);
      }
    } else {
      return Promise.reject(new Error("getAllKeysValues: Store not opened"));
    }
  }

  async removeItem(key:string): Promise<void> {
    if(this.isService && this.store != null) {
      if(key.length > 0) {
        try {
          await this.store.remove({ key });
          return Promise.resolve();
        } catch (err) {
          return Promise.reject(err);
        }
      } else {
        return Promise.reject(new Error("removeItem: Must give a key"));
      }
    } else {
      return Promise.reject(new Error("removeItem: Store not opened"));
    }
  }

  async clear(): Promise<void> {
    if(this.isService && this.store != null) {
      try {
        await this.store.clear();
        return Promise.resolve();
      } catch (err) {
          return Promise.reject(err.message);
        } 
    } else {
      return Promise.reject(new Error("clear: Store not opened"));
    }
  }

  async deleteStore(_dbName?:string): Promise<void> {
    const database: string = _dbName ? _dbName : "storage";
    await this.init();
    if(this.isService && this.store != null) {
      try {
        await this.store.deleteStore({database});
        return Promise.resolve();
      } catch (err) {
          return Promise.reject(err.message);
      } 
    } else {
      return Promise.reject(new Error("deleteStore: Store not opened"));
    }
  }
  async isTable(table:string): Promise<boolean> {
    if(this.isService && this.store != null) {
      if(table.length > 0) {
        try {
          const {result} = await this.store.isTable({ table });
          return Promise.resolve(result);
        } catch (err) {
          return Promise.reject(err);
        }
      } else {
        return Promise.reject(new Error("isTable: Must give a table"));
      }
    } else {
      return Promise.reject(new Error("isTable: Store not opened"));
    }
  }
  async getAllTables(): Promise<Array<string>> {
    if(this.isService && this.store != null) {
      try {
        const {tables} = await this.store.tables();
        return Promise.resolve(tables); 
      } catch (err) {
        return Promise.reject(err);
      }
    } else {
      return Promise.reject(new Error("getAllTables: Store not opened"));
    }
  }
  async deleteTable(table?:string): Promise<void> {
    if(this.isService && this.store != null) {
      if(table.length > 0) {
        try {
          await this.store.deleteTable({table});
          return Promise.resolve();
        } catch (err) {
            return Promise.reject(err);
        } 
      } else {
        return Promise.reject(new Error("deleteTable: Must give a table"));
      }
    } else {
      return Promise.reject(new Error("deleteTable: Store not opened"));
    }
  }
}
```

and then use it in YOUR_COMPONENT

- Store non encrypted

```ts
import { Component, AfterViewInit } from '@angular/core';
import { StoreService } from '../../services/store.service';
import { Dialog } from '@capacitor/dialog';

@Component({
  selector: 'app-teststore',
  templateUrl: './teststore.component.html',
  styleUrls: ['./teststore.component.scss'],
})
export class TeststoreComponent implements AfterViewInit {
  platform: string;
  isService: boolean = false;
  store: any = null;
  _cardStorage: HTMLIonCardElement;
  _showAlert: any;

  constructor(private _StoreService: StoreService) { }
  /*******************************
   * Component Lifecycle Methods *
   *******************************/

  async ngAfterViewInit() {
    this._showAlert = async (message: string) => {
      await Dialog.alert({
      title: 'Error Dialog',
      message: message,
      });
    };

    // Initialize the CapacitorDataStorageSQLite plugin
    await this._StoreService.init();
  }

  /*******************************
  * Component Methods           *
  *******************************/


  async runTests(): Promise<void> {
    this._cardStorage = document.querySelector('.card-storage');

    if(this._StoreService.isService) {
      // reset the Dom in case of multiple runs
      await this.resetStorageDisplay();
      try {
        await this.testFirstStore();
        document.querySelector('.store-success1').classList.remove('display');
      } catch (err) {
        document.querySelector('.store-failure1').classList.remove('display');
        await this._showAlert(err.message);
      }
    } else {
      console.log("Service is not initialized");
      document.querySelector('.store-failure1').classList.remove('display');
      await this._showAlert("Service is not initialized");
    }
  }
  async testFirstStore(): Promise<void> {
    //populate some data
    //string
    console.log('in testFirstStore ***** ')
    try {
      await this._StoreService.openStore("");
      await this._StoreService.clear();
      // store data in the first store
      await this._StoreService.setItem("session","Session Opened");
      let result: any = await this._StoreService.getItem("session");
      if (result != "Session Opened") {
        return Promise.reject(new Error("session failed"));
      }
      // json
      let data: any = {'a':20,'b':'Hello World','c':{'c1':40,'c2':'cool'}}
      await this._StoreService.setItem("testJson",JSON.stringify(data));
      result = await this._StoreService.getItem("testJson");
      if (result != JSON.stringify(data)){
        return Promise.reject(new Error("testJson failed"));
      }
      // number
      let data1: any = 243.567
      await this._StoreService.setItem("testNumber",data1.toString());
      result = await this._StoreService.getItem("testNumber");
      let ret3: boolean = false;
      if (result != data1.toString()){
        return Promise.reject(new Error("testNumber failed"));
      }
      // getting a value from a non existing key
      result = await this._StoreService.getItem("foo");
      if (result.length > 0) {
        return Promise.reject(new Error("test non existing key failed"));
      }
      // test isKey
      result = await this._StoreService.isKey("testNumber");
      console.log("isKey testNumber " + result)
      if(!result) {
        return Promise.reject(new Error("isKey testNumber failed"));
      }
      result = await this._StoreService.isKey("foo");
      console.log("isKey foo " + result)
      if(result) {
        return Promise.reject(new Error("isKey foo failed"));
      }
      // test getAllKeys
      result = await this._StoreService.getAllKeys();
      console.log("Get keys result: " + result);
  
      if(result.length != 3 || result[0] != "session"
          || result[1] != "testJson" || result[2] != "testNumber") {
        return Promise.reject(new Error("getAllKeys failed"));
      }
      // test getAllValues
      result = await this._StoreService.getAllValues();
      console.log("Get values : " + result);
      if(result.length != 3 || result[0] != "Session Opened"
          || result[1] != JSON.stringify(data) || result[2] != data1.toString()) {
        return Promise.reject(new Error("getAllValues failed"));
      }
      // test getAllKeysValues
      result = await this._StoreService.getAllKeysValues();
      if(result.length != 3 ||
          result[0].key != "session" || result[0].value != "Session Opened" ||
          result[1].key != "testJson" || result[1].value != JSON.stringify(data) ||
          result[2].key != "testNumber" || result[2].value != data1.toString()) {
        return Promise.reject(new Error("getAllKeysValues failed"));
      }
      // test removeItem
      await this._StoreService.removeItem("testJson");
      result = await this._StoreService.getAllKeysValues();
      if(result.length != 2 || 
          result[0].key != "session" || result[0].value != "Session Opened" ||
          result[1].key != "testNumber" || result[1].value != data1.toString()) {
        return Promise.reject(new Error("getAllKeysValues failed after removeItem"));
      }
      // test clear
      await this._StoreService.clear();
      result = await this._StoreService.getAllKeysValues();
      if(result.length != 0) {
        return Promise.reject(new Error("getAllKeysValues failed after clear"));
      }
      console.log('in testFirstStore end ***** ')
      return Promise.resolve();
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async resetStorageDisplay(): Promise<void> {
    for (let i:number=0;i< this._cardStorage.childElementCount;i++) {
      if(!this._cardStorage.children[i].classList.contains('display')) this._cardStorage.children[i].classList.add('display');
    }
  }
}
```

- Store encryption for `Native Platforms` only.

```ts
import { Component, AfterViewInit } from '@angular/core';
import { StoreService } from '../../services/store.service';
import { Dialog } from '@capacitor/dialog';

@Component({
  selector: 'app-encryptastore',
  templateUrl: './encryptastore.component.html',
  styleUrls: ['./encryptastore.component.scss'],
})
export class EncryptaStoreComponent implements AfterViewInit {
  platform: string;
  isService: boolean = false;
  store: any = null;
  _cardStorage: HTMLIonCardElement;
  _showAlert: any;

  constructor(private _StoreService: StoreService) { }
  /*******************************
   * Component Lifecycle Methods *
   *******************************/

  async ngAfterViewInit() {
    this._showAlert = async (message: string) => {
      await Dialog.alert({
      title: 'Error Dialog',
      message: message,
      });
    };

    // Initialize the CapacitorDataStorageSQLite plugin
    await this._StoreService.init();
    this.platform = this._StoreService.platform;
  }

  /*******************************
  * Component Methods           *
  *******************************/


  async runTests(): Promise<void> {
    this._cardStorage = document.querySelector('.card-encryptastore');

    if(this._StoreService.isService) {
      // reset the Dom in case of multiple runs
      await this.resetStorageDisplay();
      try {
        await this.testEncryptaStore();
        document.querySelector('.encryptastore-success1').classList.remove('display');
      } catch (err) {
        document.querySelector('.encryptastore-failure1').classList.remove('display');
        await this._showAlert(err.message);
      }
    } else {
      console.log("Service is not initialized");
      document.querySelector('.encryptastore-failure1').classList.remove('display');
      await this._showAlert("Service is not initialized");
    }
  }
  async testEncryptaStore(): Promise<void> {
    //populate some data
    //string
    console.log('in testEncryptaStore ***** ')
    try {
      // ********************************************
      // * check if the store exists and deletes it *
      // ********************************************
      let result: any = await this._StoreService.isStoreExists("encryptStore");
      if(result) {
        await this._StoreService.deleteStore("encryptStore");
      }
      // ******************
      // * create a store *
      // ******************
      await this._StoreService.openStore("encryptStore", "saveData");
      await this._StoreService.clear();
      // store data in the "saveData" table
      await this._StoreService.setItem("app","App Opened");
      result = await this._StoreService.getItem("app");
      if (result != "App Opened") {
        return Promise.reject(new Error("app failed"));
      }
      // json
      let data: any = {'age':40,'name':'jeep','email':'jeep@example.com'};
      await this._StoreService.setItem("user",JSON.stringify(data));
      result = await this._StoreService.getItem("user");
      if (result != JSON.stringify(data)){
        return Promise.reject(new Error("user failed"));
      }
      // set a new table "otherData"
      await this._StoreService.setTable("otherData");
      await this._StoreService.clear();
      // store data in the "saveData" table
      await this._StoreService.setItem("key1","Hello World");
      result = await this._StoreService.getItem("key1");
      if (result != "Hello World") {
        return Promise.reject(new Error("key1 failed"));
      }
      // json
      let data1: any= {'a':60,'pi':'3.141516','b':'cool'};
      await this._StoreService.setItem("key2",JSON.stringify(data1));
      result = await this._StoreService.getItem("key2");
      if (result != JSON.stringify(data1)){
        return Promise.reject(new Error("key2 failed"));
      }
      // close the store
      if(this.platform === "android") {
        await this._StoreService.closeStore("encryptStore");
      }

      // *******************
      // * encrypt a store *
      // *******************
      await this._StoreService.openStore("encryptStore", "saveData", true,
                                         "encryption");
      // test getAllTables
      result = await this._StoreService.getAllTables();
      console.log("Get tables result: " + result);
  
      if(result.length != 2 || !result.includes("saveData")
          || !result.includes("otherData")) {
        return Promise.reject(new Error("getAllTables 1 failed"));
      }
      // store new data in "saveData" table
      await this._StoreService.setTable("saveData");
      await this._StoreService.setItem("message","Welcome from Jeep");
      result = await this._StoreService.getItem("message");
      if (result != "Welcome from Jeep") {
        return Promise.reject(new Error("message failed"));
      }
      // test getAllKeysValues
      result = await this._StoreService.getAllKeysValues();
      if(result.length != 3 ||
          result[0].key != "app" || result[0].value != "App Opened" ||
          result[1].key != "user" || result[1].value != JSON.stringify(data) ||
          result[2].key != "message" || result[2].value != "Welcome from Jeep") {
        return Promise.reject(new Error("getAllKeysValues failed"));
      }
      // close the store
      if(this.platform === "android") {
        await this._StoreService.closeStore("encryptStore");
      }

      console.log('in testEncryptaStore end ***** ')
      return Promise.resolve();
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async resetStorageDisplay(): Promise<void> {
    for (let i:number=0;i< this._cardStorage.childElementCount;i++) {
      if(!this._cardStorage.children[i].classList.contains('display')) this._cardStorage.children[i].classList.add('display');
    }
  }
}

```

- MultiTables Store

```ts
import { Component, AfterViewInit } from '@angular/core';
import { StoreService } from '../../services/store.service';
import { Dialog } from '@capacitor/dialog';

@Component({
  selector: 'app-multitables-store',
  templateUrl: './multitablesstore.component.html',
  styleUrls: ['./multitablesstore.component.scss'],
})
export class MultitablesstoreComponent implements AfterViewInit {
  platform: string;
  isService: boolean = false;
  store: any = null;
  _cardStorage: HTMLIonCardElement;
  _showAlert: any;

  constructor(private _StoreService: StoreService) { }
  /*******************************
   * Component Lifecycle Methods *
   *******************************/

  async ngAfterViewInit() {
    this._showAlert = async (message: string) => {
      await Dialog.alert({
      title: 'Error Dialog',
      message: message,
      });
    };

    // Initialize the CapacitorDataStorageSQLite plugin
    await this._StoreService.init();
    this.platform = this._StoreService.platform;
  }

  /*******************************
  * Component Methods           *
  *******************************/


  async runTests(): Promise<void> {
    this._cardStorage = document.querySelector('.card-multitablesstore');

    if(this._StoreService.isService) {
      // reset the Dom in case of multiple runs
      await this.resetStorageDisplay();
      try {
        await this.testMultiTablesStore();
        document.querySelector('.multitables-store-success1').classList.remove('display');
      } catch (err) {
        document.querySelector('.multitables-store-failure1').classList.remove('display');
        await this._showAlert(err.message);
      }
    } else {
      console.log("Service is not initialized");
      document.querySelector('.multitables-store-failure1').classList.remove('display');
      await this._showAlert("Service is not initialized");
    }
  }
  async testMultiTablesStore(): Promise<void> {
    //populate some data
    //string
    console.log('in testMultiTablesStore ***** ')
    try {
      await this._StoreService.openStore("myStore", "saveData");
      await this._StoreService.clear();
      // store data in the "saveData" table
      await this._StoreService.setItem("app","App Opened");
      let result: any = await this._StoreService.getItem("app");
      if (result != "App Opened") {
        return Promise.reject(new Error("app failed"));
      }
      // json
      let data: any = {'age':40,'name':'jeep','email':'jeep@example.com'};
      await this._StoreService.setItem("user",JSON.stringify(data));
      result = await this._StoreService.getItem("user");
      if (result != JSON.stringify(data)){
        return Promise.reject(new Error("user failed"));
      }
      // set a new table "otherData"
      await this._StoreService.setTable("otherData");
      await this._StoreService.clear();
      // store data in the "saveData" table
      await this._StoreService.setItem("key1","Hello World");
      result = await this._StoreService.getItem("key1");
      if (result != "Hello World") {
        return Promise.reject(new Error("key1 failed"));
      }
      // json
      let data1: any= {'a':60,'pi':'3.141516','b':'cool'};
      await this._StoreService.setItem("key2",JSON.stringify(data1));
      result = await this._StoreService.getItem("key2");
      if (result != JSON.stringify(data1)){
        return Promise.reject(new Error("key2 failed"));
      }
      // store new data in "saveData" table
      await this._StoreService.setTable("saveData");
      await this._StoreService.setItem("message","Welcome from Jeep");
      result = await this._StoreService.getItem("message");
      if (result != "Welcome from Jeep") {
        return Promise.reject(new Error("message failed"));
      }
      // test getAllKeysValues
      result = await this._StoreService.getAllKeysValues();
      console.log(`getAllKeysValues result: ${JSON.stringify(result)}`)
      if(result.length != 3 ||
          result[0].key != "app" || result[0].value != "App Opened" ||
          result[1].key != "message" || result[1].value != "Welcome from Jeep" ||
          result[2].key != "user" || result[2].value != JSON.stringify(data)) {
        return Promise.reject(new Error("getAllKeysValues failed"));
      }

      // test isTable
      if(this.platform !== "web") {
        result = await this._StoreService.isTable("saveData");
        console.log("isTable saveData " + result)
        if(!result) {
          return Promise.reject(new Error("isTable saveData failed"));
        }
        result = await this._StoreService.isTable("foo");
        console.log("isTable foo " + result)
        if(result) {
          return Promise.reject(new Error("isTable foo failed"));
        }

        // test getAllTables
        result = await this._StoreService.getAllTables();
        console.log("Get tables result: " + result);
    
        if(result.length != 2 || !result.includes("saveData")
            || !result.includes("otherData")) {
          return Promise.reject(new Error("getAllTables 1 failed"));
        }
        // test deleteTable
        await this._StoreService.deleteTable("otherData");
        // test getAllTables
        result = await this._StoreService.getAllTables();
        console.log("Get tables result: " + result);
    
        if(result.length != 1 || !result.includes("saveData")) {
          return Promise.reject(new Error("getAllTables 2 failed"));
        }

        // test if "myStore" is opened
        result = await this._StoreService.isStoreOpen("myStore");
        if(result) await this._StoreService.closeStore("myStore");
        // check if "myStore" exists
        result = await this._StoreService.isStoreExists("myStore");
        if(!result.result) {
          return Promise.reject(new Error("isStoreExists 1 failed"));
        }
        // delete the Store 
        await this._StoreService.deleteStore("myStore");      
        // check if "myStore" exists
        result = await this._StoreService.isStoreExists("myStore");
        if(result.result) {
          return Promise.reject(new Error("isStoreExists 2 failed"));
        }
      }
      console.log('in testMultiTablesStore end ***** ')
      return Promise.resolve();
    } catch (err) {
      return Promise.reject(err);
    }
  }
  async resetStorageDisplay(): Promise<void> {
    for (let i:number=0;i< this._cardStorage.childElementCount;i++) {
      if(!this._cardStorage.children[i].classList.contains('display')) this._cardStorage.children[i].classList.add('display');
    }
  }
}

```

