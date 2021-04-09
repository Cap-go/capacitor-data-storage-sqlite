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
   * Open a Database
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
}

```

and then use it in YOUR_COMPONENT

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

