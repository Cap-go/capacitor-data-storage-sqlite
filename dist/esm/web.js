var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
import { WebPlugin, registerWebPlugin } from '@capacitor/core';
import { StorageDatabaseHelper } from './web-utils/StorageDatabaseHelper';
import { Data } from './web-utils/data';
export class CapacitorDataStorageIdbWeb extends WebPlugin {
    constructor() {
        super({
            name: 'CapacitorDataStorageSqlite',
            platforms: ['web']
        });
        this.mDb = new StorageDatabaseHelper();
    }
    set(options) {
        return __awaiter(this, void 0, void 0, function* () {
            let ret;
            let key = options.key;
            if (key == null) {
                return Promise.reject("Must provide key");
            }
            let value = options.value;
            if (value == null) {
                return Promise.reject("Must provide value");
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
                return Promise.reject("Must provide key");
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
            if (key == null) {
                return Promise.reject("Must provide key");
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
                return Promise.reject("Must provide key");
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
            let ret;
            ret = yield this.mDb.keysvalues();
            return Promise.resolve({ keysvalues: ret });
        });
    }
}
const CapacitorDataStorageSqlite = new CapacitorDataStorageIdbWeb();
registerWebPlugin(CapacitorDataStorageSqlite);
export { CapacitorDataStorageSqlite };
//# sourceMappingURL=web.js.map