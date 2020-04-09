var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
import { WebPlugin } from '@capacitor/core';
import { StorageDatabaseHelper } from './electron-utils/StorageDatabaseHelper';
import { Data } from './electron-utils/Data';
export class CapacitorDataStorageSqlitePluginElectron extends WebPlugin {
    constructor() {
        super({
            name: 'CapacitorDataStorageSqlite',
            platforms: ['electron']
        });
        this.mDb = new StorageDatabaseHelper();
    }
    echo(options) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log('ECHO in Electron Plugin', options);
            return options;
        });
    }
    openStore(options) {
        return __awaiter(this, void 0, void 0, function* () {
            let ret = false;
            let dbName = options.database ? `${options.database}SQLite.db` : "storageSQLite.db";
            let tableName = options.table ? options.table : "storage_store";
            ret = yield this.mDb.openStore(dbName, tableName);
            return Promise.resolve({ result: ret });
        });
    }
    setTable(options) {
        return __awaiter(this, void 0, void 0, function* () {
            let tableName = options.table;
            if (tableName == null) {
                return Promise.reject({ result: false, message: "Must provide a table name" });
            }
            let ret = false;
            let message = "";
            if (this.mDb) {
                ret = yield this.mDb.setTable(tableName);
                if (ret) {
                    return Promise.resolve({ result: ret, message: message });
                }
                else {
                    return Promise.reject({ result: ret, message: "failed in adding table" });
                }
            }
            else {
                return Promise.reject({ result: ret, message: "Must open a store first" });
            }
        });
    }
    set(options) {
        return __awaiter(this, void 0, void 0, function* () {
            let ret;
            let key = options.key;
            if (key == null) {
                return Promise.reject({ result: false, message: "Must provide key" });
            }
            let value = options.value;
            if (value == null) {
                return Promise.reject({ result: false, message: "Must provide value" });
            }
            let data = new Data();
            data.name = key;
            data.value = value;
            ret = yield this.mDb.set(data);
            return Promise.resolve({ result: ret });
        });
    }
    get(options) {
        return __awaiter(this, void 0, void 0, function* () {
            let ret;
            let key = options.key;
            if (key == null) {
                return Promise.reject({ result: false, message: "Must provide key" });
            }
            let data = yield this.mDb.get(key);
            ret = data != null && data.id != null ? data.value : null;
            return Promise.resolve({ value: ret });
        });
    }
    remove(options) {
        return __awaiter(this, void 0, void 0, function* () {
            let ret;
            let key = options.key;
            if (key == null) {
                return Promise.reject({ result: false, message: "Must provide key" });
            }
            ret = yield this.mDb.remove(key);
            return Promise.resolve({ result: ret });
        });
    }
    clear() {
        return __awaiter(this, void 0, void 0, function* () {
            let ret;
            ret = yield this.mDb.clear();
            return Promise.resolve({ result: ret });
        });
    }
    iskey(options) {
        return __awaiter(this, void 0, void 0, function* () {
            let ret;
            let key = options.key;
            if (key == null) {
                return Promise.reject({ result: false, message: "Must provide key" });
            }
            ret = yield this.mDb.iskey(key);
            return Promise.resolve({ result: ret });
        });
    }
    keys() {
        return __awaiter(this, void 0, void 0, function* () {
            let ret;
            ret = yield this.mDb.keys();
            return Promise.resolve({ keys: ret });
        });
    }
    values() {
        return __awaiter(this, void 0, void 0, function* () {
            let ret;
            ret = yield this.mDb.values();
            return Promise.resolve({ values: ret });
        });
    }
    keysvalues() {
        return __awaiter(this, void 0, void 0, function* () {
            let ret = [];
            let results;
            results = yield this.mDb.keysvalues();
            for (let i = 0; i < results.length; i++) {
                let res = { "key": results[i].name, "value": results[i].value };
                ret.push(res);
            }
            return Promise.resolve({ keysvalues: ret });
        });
    }
    deleteStore(options) {
        return __awaiter(this, void 0, void 0, function* () {
            let dbName = options.database;
            if (dbName == null) {
                return Promise.reject({ result: false, message: "Must provide a Database Name" });
            }
            dbName = `${options.database}SQLite.db`;
            if (typeof this.mDb === 'undefined' || this.mDb === null)
                this.mDb = new StorageDatabaseHelper();
            const ret = yield this.mDb.deleteStore(dbName);
            this.mDb = null;
            return Promise.resolve({ result: ret });
        });
    }
}
const CapacitorDataStorageSqliteElectron = new CapacitorDataStorageSqlitePluginElectron();
export { CapacitorDataStorageSqliteElectron };
import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(CapacitorDataStorageSqliteElectron);
//# sourceMappingURL=electron.js.map