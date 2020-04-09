var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
//import * as sqlite3 from 'sqlite3';
import { Data } from './Data';
import { UtilsSQLite } from './UtilsSQLite';
const COL_ID = "id";
const COL_NAME = "name";
const COL_VALUE = "value";
const fs = window['fs'];
const path = window['path'];
export class StorageDatabaseHelper {
    constructor() {
        this._utils = new UtilsSQLite();
    }
    openStore(dbName, tableName) {
        return new Promise((resolve) => {
            let ret = false;
            this._db = this._utils.connection(dbName, false /*,this._secret*/);
            if (this._db !== null) {
                this._createTable(tableName);
                this._dbName = dbName;
                this._tableName = tableName;
                ret = true;
            }
            resolve(ret);
        });
    }
    _createTable(tableName) {
        const CREATE_STORAGE_TABLE = "CREATE TABLE IF NOT EXISTS " + tableName +
            "(" +
            COL_ID + " INTEGER PRIMARY KEY AUTOINCREMENT," + // Define a primary key
            COL_NAME + " TEXT NOT NULL UNIQUE," +
            COL_VALUE + " TEXT" +
            ")";
        try {
            this._db.run(CREATE_STORAGE_TABLE, this._createIndex.bind(this, tableName));
        }
        catch (e) {
            console.log('Error: in createTable ', e);
        }
    }
    _createIndex(tableName) {
        const idx = `index_${tableName}_on_${COL_NAME}`;
        const CREATE_INDEX_NAME = "CREATE INDEX IF NOT EXISTS " + idx + " ON " + tableName +
            " (" + COL_NAME + ")";
        try {
            this._db.run(CREATE_INDEX_NAME);
        }
        catch (e) {
            console.log('Error: in createIndex ', e);
        }
    }
    setTable(tableName) {
        return new Promise((resolve) => __awaiter(this, void 0, void 0, function* () {
            let ret = false;
            this._db = this._utils.getWritableDatabase(this._dbName /*,this._secret*/);
            try {
                this._createTable(tableName);
                this._tableName = tableName;
                ret = true;
                console.log('create table successfull ', this._tableName);
            }
            catch (e) {
                console.log('Error: in createTable ', e);
            }
            finally {
                this._db.close();
                resolve(ret);
            }
        }));
    }
    // Insert a data into the database
    set(data) {
        return new Promise((resolve) => __awaiter(this, void 0, void 0, function* () {
            const db = this._utils.getWritableDatabase(this._dbName /*,this._secret*/);
            // Check if data.name does not exist otherwise update it
            const res = yield this.get(data.name);
            if (res.id != null) {
                // exists so update it
                const resUpd = yield this.update(data);
                db.close();
                resolve(resUpd);
            }
            else {
                // does not exist add it
                const DATA_INSERT = `INSERT INTO "${this._tableName}" 
                ("${COL_NAME}", "${COL_VALUE}") 
                VALUES (?, ?)`;
                db.run(DATA_INSERT, [data.name, data.value], (err) => {
                    if (err) {
                        console.log('Data INSERT: ', err.message);
                        db.close();
                        resolve(false);
                    }
                    else {
                        db.close();
                        resolve(true);
                    }
                });
            }
        }));
    }
    // get a Data
    get(name) {
        return new Promise((resolve) => {
            let data = null;
            const db = this._utils.getReadableDatabase(this._dbName /*,this._secret*/);
            const DATA_SELECT_QUERY = "SELECT * FROM " + this._tableName +
                " WHERE " + COL_NAME + " = '" + name + "'";
            db.all(DATA_SELECT_QUERY, (err, rows) => {
                if (err) {
                    data = new Data();
                    data.id = null;
                    db.close();
                    resolve(data);
                }
                else {
                    data = new Data();
                    if (rows.length >= 1) {
                        data = rows[0];
                    }
                    else {
                        data.id = null;
                    }
                    db.close();
                    resolve(data);
                }
            });
        });
    }
    // update a Data
    update(data) {
        return new Promise((resolve) => {
            const db = this._utils.getWritableDatabase(this._dbName /*,this._secret*/);
            const DATA_UPDATE = `UPDATE "${this._tableName}" 
            SET "${COL_VALUE}" = ? WHERE "${COL_NAME}" = ?`;
            db.run(DATA_UPDATE, [data.value, data.name], (err) => {
                if (err) {
                    console.log('Data UPDATE: ', err.message);
                    db.close();
                    resolve(false);
                }
                else {
                    db.close();
                    resolve(true);
                }
            });
        });
    }
    // isKey exists
    iskey(name) {
        return new Promise((resolve) => __awaiter(this, void 0, void 0, function* () {
            const res = yield this.get(name);
            if (res.id != null) {
                resolve(true);
            }
            else {
                resolve(false);
            }
        }));
    }
    // remove a key
    remove(name) {
        return new Promise((resolve) => __awaiter(this, void 0, void 0, function* () {
            const res = yield this.get(name);
            if (res.id != null) {
                const db = this._utils.getWritableDatabase(this._dbName /*,this._secret*/);
                const DATA_DELETE = `DELETE FROM "${this._tableName}" 
                WHERE "${COL_NAME}" = ?`;
                db.run(DATA_DELETE, name, (err) => {
                    if (err) {
                        console.log('Data DELETE: ', err.message);
                        db.close();
                        resolve(false);
                    }
                    else {
                        db.close();
                        resolve(true);
                    }
                });
            }
            else {
                console.log('Error:REMOVE key does not exist');
                resolve(false);
            }
        }));
    }
    // remove all keys 
    clear() {
        return new Promise((resolve) => __awaiter(this, void 0, void 0, function* () {
            const db = this._utils.getWritableDatabase(this._dbName /*,this._secret*/);
            const DATA_DELETE = `DELETE FROM "${this._tableName}"`;
            db.run(DATA_DELETE, [], (err) => {
                if (err) {
                    console.log('Data CLEAR: ', err.message);
                    db.close();
                    resolve(false);
                }
                else {
                    // set back the key primary index to 0
                    const DATA_UPDATE = `UPDATE SQLITE_SEQUENCE 
                    SET SEQ = ? `;
                    db.run(DATA_UPDATE, 0, (err) => {
                        if (err) {
                            console.log('Data UPDATE SQLITE_SEQUENCE: ', err.message);
                            db.close();
                            resolve(false);
                        }
                        else {
                            db.close();
                            resolve(true);
                        }
                    });
                }
            });
        }));
    }
    keys() {
        return new Promise((resolve) => {
            const db = this._utils.getReadableDatabase(this._dbName /*,this._secret*/);
            const DATA_SELECT_KEYS = `SELECT "${COL_NAME}" FROM "${this._tableName}"`;
            db.all(DATA_SELECT_KEYS, (err, rows) => {
                if (err) {
                    db.close();
                    resolve([]);
                }
                else {
                    let arKeys = [];
                    for (let i = 0; i < rows.length; i++) {
                        arKeys = [...arKeys, rows[i].name];
                        if (i === rows.length - 1) {
                            db.close();
                            resolve(arKeys);
                        }
                    }
                }
            });
        });
    }
    values() {
        return new Promise((resolve) => {
            const db = this._utils.getReadableDatabase(this._dbName /*,this._secret*/);
            const DATA_SELECT_VALUES = `SELECT "${COL_VALUE}" FROM "${this._tableName}"`;
            db.all(DATA_SELECT_VALUES, (err, rows) => {
                if (err) {
                    db.close();
                    resolve([]);
                }
                else {
                    let arValues = [];
                    for (let i = 0; i < rows.length; i++) {
                        arValues = [...arValues, rows[i].value];
                        if (i === rows.length - 1) {
                            db.close();
                            resolve(arValues);
                        }
                    }
                }
            });
        });
    }
    keysvalues() {
        return new Promise((resolve) => {
            const db = this._utils.getReadableDatabase(this._dbName /*,this._secret*/);
            const DATA_SELECT_KEYSVALUES = `SELECT "${COL_NAME}" , "${COL_VALUE}" FROM "${this._tableName}"`;
            db.all(DATA_SELECT_KEYSVALUES, (err, rows) => {
                if (err) {
                    db.close();
                    resolve([]);
                }
                else {
                    db.close();
                    resolve(rows);
                }
            });
        });
    }
    deleteStore(dbName) {
        return new Promise((resolve) => {
            let ret = false;
            const dbPath = path.join(this._utils.pathDB, dbName);
            try {
                fs.unlinkSync(dbPath);
                //file removed
                ret = true;
            }
            catch (e) {
                console.log("Error: in deleteStore");
            }
            resolve(ret);
        });
    }
}
//# sourceMappingURL=StorageDatabaseHelper.js.map