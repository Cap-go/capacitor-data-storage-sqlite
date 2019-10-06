import LocalForage from 'jeep-localforage';
import { Data } from "./Data";
const DATABASE = "storageIDB";
const STORAGESTORE = "storage_store";
export class StorageDatabaseHelper {
    constructor() {
        let config = {
            name: DATABASE,
            storeName: STORAGESTORE,
            driver: [LocalForage.INDEXEDDB, LocalForage.WEBSQL],
            version: 1
        };
        this._db = LocalForage.createInstance(config);
    }
    set(data) {
        return this._db.setItem(data.name, data.value).then(() => {
            return Promise.resolve(true);
        })
            .catch((error) => {
            console.log('set: Error Data insertion failed: ' + error);
            return Promise.resolve(false);
        });
    }
    get(name) {
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
    }
    remove(name) {
        return this._db.removeItem(name).then(() => {
            return Promise.resolve(true);
        })
            .catch((error) => {
            console.log('remove: Error Data remove failed: ' + error);
            return Promise.resolve(false);
        });
    }
    clear() {
        return this._db.clear().then(() => {
            return Promise.resolve(true);
        })
            .catch((error) => {
            console.log('clear: Error Data clear failed: ' + error);
            return Promise.resolve(false);
        });
    }
    keys() {
        return this._db.keys().then((keys) => {
            return Promise.resolve(keys);
        })
            .catch((error) => {
            console.log('keys: Error Data retrieve keys failed: ' + error);
            return Promise.resolve(null);
        });
    }
    values() {
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
    }
    keysvalues() {
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
    }
    iskey(name) {
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
    }
}
//# sourceMappingURL=StorageDatabaseHelper.js.map