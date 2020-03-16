var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
import LocalForage from 'jeep-localforage';
import { Data } from "./Data";
//const DATABASE: string = "storageIDB";
//const STORAGESTORE: string = "storage_store";
export class StorageDatabaseHelper {
    constructor(dbName, tableName) {
        this._db = null;
        this.openStore(dbName, tableName);
    }
    openStore(dbName, tableName) {
        let ret = false;
        const config = this.setConfig(dbName, tableName);
        this._db = LocalForage.createInstance(config);
        if (this._db != null) {
            this._dbName = dbName;
            ret = true;
        }
        return ret;
    }
    setConfig(dbName, tableName) {
        let config = {
            name: dbName,
            storeName: tableName,
            driver: [LocalForage.INDEXEDDB, LocalForage.WEBSQL],
            version: 1
        };
        return config;
    }
    setTable(tableName) {
        return __awaiter(this, void 0, void 0, function* () {
            return this.openStore(this._dbName, tableName);
        });
    }
    set(data) {
        return __awaiter(this, void 0, void 0, function* () {
            return this._db.setItem(data.name, data.value).then(() => {
                return Promise.resolve(true);
            })
                .catch((error) => {
                console.log('set: Error Data insertion failed: ' + error);
                return Promise.resolve(false);
            });
        });
    }
    get(name) {
        return __awaiter(this, void 0, void 0, function* () {
            return this._db.getItem(name).then((value) => {
                let data = new Data();
                data.name = name;
                data.value = value;
                return Promise.resolve(data);
            })
                .catch((error) => {
                console.log('get: Error Data retrieve failed: ' + error);
                return Promise.resolve(null);
            });
        });
    }
    remove(name) {
        return __awaiter(this, void 0, void 0, function* () {
            return this._db.removeItem(name).then(() => {
                return Promise.resolve(true);
            })
                .catch((error) => {
                console.log('remove: Error Data remove failed: ' + error);
                return Promise.resolve(false);
            });
        });
    }
    clear() {
        return __awaiter(this, void 0, void 0, function* () {
            return this._db.clear().then(() => {
                return Promise.resolve(true);
            })
                .catch((error) => {
                console.log('clear: Error Data clear failed: ' + error);
                return Promise.resolve(false);
            });
        });
    }
    keys() {
        return __awaiter(this, void 0, void 0, function* () {
            return this._db.keys().then((keys) => {
                return Promise.resolve(keys);
            })
                .catch((error) => {
                console.log('keys: Error Data retrieve keys failed: ' + error);
                return Promise.resolve(null);
            });
        });
    }
    values() {
        return __awaiter(this, void 0, void 0, function* () {
            let values = [];
            return this._db.iterate(((value) => {
                values.push(value);
            })).then(() => {
                return Promise.resolve(values);
            })
                .catch((error) => {
                console.log('values: Error Data retrieve values failed: ' + error);
                return Promise.resolve(null);
            });
        });
    }
    keysvalues() {
        return __awaiter(this, void 0, void 0, function* () {
            let keysvalues = [];
            return this._db.iterate(((value, key) => {
                let data = new Data();
                data.name = key;
                data.value = value;
                keysvalues.push(data);
            })).then(() => {
                return Promise.resolve(keysvalues);
            })
                .catch((error) => {
                console.log('keysvalues: Error Data retrieve keys/values failed: ' + error);
                return Promise.resolve(null);
            });
        });
    }
    iskey(name) {
        return __awaiter(this, void 0, void 0, function* () {
            return this.get(name).then((data) => {
                if (data.value != null) {
                    return Promise.resolve(true);
                }
                else {
                    return Promise.resolve(false);
                }
            })
                .catch((error) => {
                console.log('iskey: Error Data retrieve iskey failed: ' + error);
                return Promise.resolve(false);
            });
        });
    }
}
//# sourceMappingURL=StorageDatabaseHelper.js.map