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
import { StorageDatabaseHelper } from './web-utils/StorageDatabaseHelper';
import { Data } from './web-utils/Data';
export class CapacitorDataStorageSqliteWeb extends WebPlugin {
    constructor() {
        super({
            name: 'CapacitorDataStorageSqlite',
            platforms: ['web']
        });
    }
    echo(options) {
        return __awaiter(this, void 0, void 0, function* () {
            console.log('ECHO', options);
            return options;
        });
    }
    openStore(options) {
        return __awaiter(this, void 0, void 0, function* () {
            let ret = false;
            let dbName = options.database ? `${options.database}IDB` : "storageIDB";
            let tableName = options.table ? options.table : "storage_store";
            this.mDb = new StorageDatabaseHelper(dbName, tableName);
            if (this.mDb)
                ret = true;
            return Promise.resolve({ result: ret });
        });
    }
    setTable(options) {
        return __awaiter(this, void 0, void 0, function* () {
            let tableName = options.table;
            if (tableName == null) {
                return Promise.reject("Must provide a table name");
            }
            let ret = false;
            let message = "";
            if (this.mDb) {
                ret = yield this.mDb.setTable(tableName);
                if (ret) {
                    return Promise.resolve({ result: ret, message: message });
                }
                else {
                    return Promise.resolve({ result: ret, message: "failed in adding table" });
                }
            }
            else {
                return Promise.resolve({ result: ret, message: "Must open a store first" });
            }
        });
    }
    set(options) {
        return __awaiter(this, void 0, void 0, function* () {
            let ret;
            let key = options.key;
            if (key == null || typeof key != "string") {
                return Promise.reject("Must provide key as string");
            }
            let value = options.value;
            if (value == null || typeof value != "string") {
                return Promise.reject("Must provide value as string");
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
            if (key == null || typeof key != "string") {
                return Promise.reject("Must provide key as string");
            }
            let data = yield this.mDb.get(key);
            ret = data != null ? data.value : null;
            return Promise.resolve({ value: ret });
        });
    }
    remove(options) {
        return __awaiter(this, void 0, void 0, function* () {
            let ret;
            let key = options.key;
            if (key == null || typeof key != "string") {
                return Promise.reject("Must provide key as string");
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
            if (key == null || typeof key != "string") {
                return Promise.reject("Must provide key as string");
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
            console.log('deleteStore', options);
            return Promise.reject("Not implemented");
        });
    }
}
const CapacitorDataStorageSqlite = new CapacitorDataStorageSqliteWeb();
export { CapacitorDataStorageSqlite };
import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(CapacitorDataStorageSqlite);
//# sourceMappingURL=web.js.map