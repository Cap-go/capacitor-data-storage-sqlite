import type {
  capDataStorageOptions,
  JsonStore,
  JsonTable,
} from '../../../src/definitions';

import { Data } from './Data';
import { UtilsSQLite } from './UtilsSQLite';

const COL_ID = 'id';
const COL_NAME = 'name';
const COL_VALUE = 'value';

export class StorageDatabaseHelper {
  Path: any = null;
  NodeFs: any = null;
  public db: any;
  public isOpen = false;
  public dbName: string;
  public tableName: string;
  //    private _secret: string = "";
  private _utils: UtilsSQLite;

  constructor() {
    this.Path = require('path');
    this.NodeFs = require('fs');
    this._utils = new UtilsSQLite();
  }

  public async openStore(dbName: string, tableName: string): Promise<void> {
    try {
      this.db = await this._utils.connection(
        dbName,
        false,
        /*,this._secret*/
      );
      if (this.db !== null) {
        await this._createTable(tableName);
        this.dbName = dbName;
        this.tableName = tableName;
        this.isOpen = true;
        return Promise.resolve();
      } else {
        this.dbName = '';
        this.tableName = '';
        this.isOpen = false;
        return Promise.reject(`connection to store ${dbName}`);
      }
    } catch (err) {
      this.dbName = '';
      this.tableName = '';
      this.isOpen = false;
      return Promise.reject(err);
    }
  }
  public async closeStore(dbName: string): Promise<void> {
    if (dbName === this.dbName && this.isOpen && this.db != null) {
      try {
        await this.db.close();
        this.dbName = '';
        this.tableName = '';
        this.isOpen = false;
        return Promise.resolve();
      } catch (err) {
        return Promise.reject(err);
      }
    } else {
      return Promise.reject(`Store ${dbName} not opened`);
    }
  }
  public async isStoreExists(dbName: string): Promise<boolean> {
    let ret = false;
    try {
      ret = await this._utils.isFileExists(dbName);
      return Promise.resolve(ret);
    } catch (err) {
      return Promise.reject(err);
    }
  }
  private async _createTable(tableName: string): Promise<void> {
    const CREATE_STORAGE_TABLE =
      'CREATE TABLE IF NOT EXISTS ' +
      tableName +
      '(' +
      COL_ID +
      ' INTEGER PRIMARY KEY AUTOINCREMENT,' + // Define a primary key
      COL_NAME +
      ' TEXT NOT NULL UNIQUE,' +
      COL_VALUE +
      ' TEXT' +
      ')';
    try {
      if (this.db != null) {
        return this.db.run(CREATE_STORAGE_TABLE, async (err: Error) => {
          if (err) {
            return Promise.reject(`Error: in createTable ${err.message}`);
          } else {
            try {
              await this._createIndex(tableName);
              return Promise.resolve();
            } catch (err) {
              return Promise.reject(err);
            }
          }
        });
      } else {
        return Promise.reject(`connection to store ${this.dbName}`);
      }
    } catch (err) {
      return Promise.reject(err);
    }
  }
  private async _createIndex(tableName: string): Promise<void> {
    const idx = `index_${tableName}_on_${COL_NAME}`;
    const CREATE_INDEX_NAME =
      'CREATE INDEX IF NOT EXISTS ' +
      idx +
      ' ON ' +
      tableName +
      ' (' +
      COL_NAME +
      ')';
    try {
      if (this.db != null) {
        return this.db.run(CREATE_INDEX_NAME, async (err: Error) => {
          if (err) {
            return Promise.reject(`Error: in createIndex ${err.message}`);
          } else {
            return Promise.resolve();
          }
        });
      } else {
        return Promise.reject(`connection to store ${this.dbName}`);
      }
    } catch (err) {
      return Promise.reject(err);
    }
  }

  public async setTable(tableName: string): Promise<void> {
    try {
      await this._createTable(tableName);
      this.tableName = tableName;
      return Promise.resolve();
    } catch (err) {
      this.tableName = '';
      return Promise.reject(err);
    }
  }

  // Insert a data into the database
  public async set(data: Data): Promise<void> {
    if (this.db == null) {
      return Promise.reject(`this.db is null in set`);
    }
    try {
      // Check if data.name does not exist otherwise update it
      const res: Data = await this.get(data.name);
      if (res.id != null) {
        // exists so update it
        await this.update(data);
        return Promise.resolve();
      } else {
        // does not exist add it
        const DATA_INSERT = `INSERT INTO "${this.tableName}" 
                                ("${COL_NAME}", "${COL_VALUE}") 
                                VALUES (?, ?)`;
        return this.db.run(
          DATA_INSERT,
          [data.name, data.value],
          (err: Error) => {
            if (err) {
              return Promise.reject(`Data INSERT: ${err.message}`);
            } else {
              return Promise.resolve();
            }
          },
        );
      }
    } catch (err) {
      return Promise.reject(err);
    }
  }

  // get a Data
  public async get(name: string): Promise<Data> {
    return new Promise((resolve, reject) => {
      if (this.db == null) {
        reject(`this.db is null in get`);
      }
      const DATA_SELECT_QUERY = `SELECT * FROM ${this.tableName} WHERE ${COL_NAME} = '${name}'`;
      this.db.all(DATA_SELECT_QUERY, (err: Error, rows: any) => {
        if (err) {
          const data = new Data();
          data.id = null;
          resolve(data);
        } else {
          let data = new Data();
          if (rows.length >= 1) {
            data = rows[0];
          } else {
            data.id = null;
          }
          resolve(data);
        }
      });
    });
  }
  // update a Data
  public async update(data: Data): Promise<void> {
    return new Promise((resolve, reject) => {
      if (this.db == null) {
        reject(`this.db is null in update`);
      }
      const DATA_UPDATE = `UPDATE "${this.tableName}" 
                        SET "${COL_VALUE}" = ? WHERE "${COL_NAME}" = ?`;
      this.db.run(DATA_UPDATE, [data.value, data.name], (err: Error) => {
        if (err) {
          reject(`Data UPDATE: ${err.message}`);
        } else {
          resolve();
        }
      });
    });
  }
  // isKey exists
  public async iskey(name: string): Promise<boolean> {
    if (this.db == null) {
      return Promise.reject(`this.db is null in clear`);
    }
    try {
      const res: Data = await this.get(name);
      if (res.id != null) {
        return Promise.resolve(true);
      } else {
        return Promise.resolve(false);
      }
    } catch (err) {
      return Promise.reject(err);
    }
  }
  // remove a key
  public async remove(name: string): Promise<void> {
    if (this.db == null) {
      return Promise.reject(`this.db is null in clear`);
    }
    try {
      const res: Data = await this.get(name);
      if (res.id != null) {
        const DATA_DELETE = `DELETE FROM "${this.tableName}" 
                            WHERE "${COL_NAME}" = ?`;
        return this.db.run(DATA_DELETE, name, (err: Error) => {
          if (err) {
            return Promise.reject(`Data DELETE: ${err.message}`);
          } else {
            return Promise.resolve();
          }
        });
      } else {
        return Promise.reject(`REMOVE key does not exist`);
      }
    } catch (err) {
      return Promise.reject(err);
    }
  }
  // remove all keys
  public async clear(): Promise<void> {
    return new Promise((resolve, reject) => {
      if (this.db == null) {
        reject(`this.db is null in clear`);
      }
      const DATA_DELETE = `DELETE FROM "${this.tableName}"`;
      this.db.exec(DATA_DELETE, (err: Error) => {
        if (err) {
          reject(`Data CLEAR: ${err.message}`);
        } else {
          // set back the key primary index to 0
          const DATA_UPDATE = `UPDATE SQLITE_SEQUENCE SET SEQ = ? `;
          this.db.run(DATA_UPDATE, 0, (err: Error) => {
            if (err) {
              reject(`Data UPDATE SQLITE_SEQUENCE: ${err.message}`);
            } else {
              resolve();
            }
          });
        }
      });
    });
  }
  public async keys(): Promise<string[]> {
    return new Promise((resolve, reject) => {
      if (this.db == null) {
        reject(`this.db is null in clear`);
      }
      try {
        let SELECT_KEYS = `SELECT "${COL_NAME}" FROM `;
        SELECT_KEYS += `"${this.tableName}" ORDER BY ${COL_NAME};`;
        this.db.all(SELECT_KEYS, (err: Error, rows: any) => {
          if (err) {
            reject(`Keys: ${err.message}`);
          } else {
            let arKeys: string[] = [];
            for (let i = 0; i < rows.length; i++) {
              arKeys = [...arKeys, rows[i].name];
              if (i === rows.length - 1) {
                resolve(arKeys);
              }
            }
          }
        });
      } catch (err) {
        return Promise.reject(err);
      }
    });
  }
  public async values(): Promise<string[]> {
    return new Promise((resolve, reject) => {
      if (this.db == null) {
        reject(`this.db is null in clear`);
      }
      try {
        let SELECT_VALUES = `SELECT "${COL_VALUE}" FROM `;
        SELECT_VALUES += `"${this.tableName}" ORDER BY ${COL_NAME};`;
        this.db.all(SELECT_VALUES, (err: Error, rows: any) => {
          if (err) {
            reject(`Values: ${err.message}`);
          } else {
            let arValues: string[] = [];
            for (let i = 0; i < rows.length; i++) {
              arValues = [...arValues, rows[i].value];
              if (i === rows.length - 1) {
                resolve(arValues);
              }
            }
          }
        });
      } catch (err) {
        reject(err);
      }
    });
  }

  public async filtervalues(filter: string): Promise<string[]> {
    return new Promise((resolve, reject) => {
      if (this.db == null) {
        reject(`this.db is null in clear`);
      }
      try {
        if (!filter.startsWith('%') && !filter.endsWith('%')) {
          filter = '%' + filter + '%';
        }
        let SELECT_VALUES = `SELECT "${COL_VALUE}" FROM `;
        SELECT_VALUES += `"${this.tableName}" WHERE name `;
        SELECT_VALUES += `LIKE "${filter}" ORDER BY ${COL_NAME}`;
        this.db.all(SELECT_VALUES, (err: Error, rows: any) => {
          if (err) {
            reject(`FilterValues: ${err.message}`);
          } else {
            let arValues: string[] = [];
            for (let i = 0; i < rows.length; i++) {
              arValues = [...arValues, rows[i].value];
              if (i === rows.length - 1) {
                resolve(arValues);
              }
            }
          }
        });
      } catch (err) {
        reject(err);
      }
    });
  }

  public async keysvalues(): Promise<Data[]> {
    return new Promise((resolve, reject) => {
      if (this.db == null) {
        reject(`this.db is null in clear`);
      }
      try {
        let SELECT_KEYSVALUES = `SELECT "${COL_NAME}" , "${COL_VALUE}"`;
        SELECT_KEYSVALUES += ` FROM "${this.tableName}" ORDER BY ${COL_NAME};`;
        this.db.all(SELECT_KEYSVALUES, (err: Error, rows: any) => {
          if (err) {
            reject(`KeysValues: ${err.message}`);
          } else {
            resolve(rows);
          }
        });
      } catch (err) {
        reject(err);
      }
    });
  }

  public async deleteStore(dbName: string): Promise<void> {
    const dbPath = this.Path.join(this._utils.pathDB, dbName);
    try {
      this.NodeFs.unlinkSync(dbPath);
      //file removed
      return Promise.resolve();
    } catch (err) {
      return Promise.reject(err);
    }
  }
  public async isTable(table: string): Promise<boolean> {
    return new Promise((resolve, reject) => {
      if (this.db == null) {
        reject(`isTable: this.db is null`);
      }
      try {
        let ret = false;
        const SELECT_TABLES =
          'SELECT name FROM sqlite_master ' + "WHERE TYPE='table';";
        this.db.all(SELECT_TABLES, (err: Error, rows: any) => {
          if (err) {
            reject(`isTable: ${err.message}`);
          } else {
            let arTables: string[] = [];
            for (let i = 0; i < rows.length; i++) {
              arTables = [...arTables, rows[i].name];
              if (i === rows.length - 1) {
                if (arTables.includes(table)) ret = true;
                resolve(ret);
              }
            }
          }
        });
      } catch (err) {
        return Promise.reject(err);
      }
    });
  }
  public async tables(): Promise<string[]> {
    return new Promise((resolve, reject) => {
      try {
        const SELECT_TABLES =
          'SELECT name FROM sqlite_master ' +
          "WHERE TYPE='table' ORDER BY name;";
        this.db.all(SELECT_TABLES, (err: Error, rows: any) => {
          if (err) {
            reject(`tables: ${err.message}`);
          } else {
            let arTables: string[] = [];
            for (let i = 0; i < rows.length; i++) {
              if (rows[i].name != 'sqlite_sequence') {
                arTables = [...arTables, rows[i].name];
              }
              if (i === rows.length - 1) {
                resolve(arTables);
              }
            }
          }
        });
      } catch (err) {
        return Promise.reject(err);
      }
    });
  }
  public async deleteTable(table: string): Promise<void> {
    if (this.db == null) {
      return Promise.reject(`this.db is null in deleteTable`);
    }
    try {
      const ret = await this.isTable(table);
      if (ret) {
        const DROP_STMT = `DROP TABLE IF EXISTS ${table};`;
        return this.db.exec(DROP_STMT, (err: Error) => {
          if (err) {
            return Promise.reject(`deleteTable: ${err.message}`);
          } else {
            return Promise.resolve();
          }
        });
      } else {
        return Promise.resolve();
      }
    } catch (err) {
      return Promise.reject(err);
    }
  }
  public async importJson(values: capDataStorageOptions[]): Promise<number> {
    let changes = 0;
    for (const val of values) {
      try {
        const data: Data = new Data();
        data.name = val.key;
        data.value = val.value;
        await this.set(data);
        changes += 1;
      } catch (err) {
        return Promise.reject(err);
      }
    }
    return Promise.resolve(changes);
  }

  public async exportJson(): Promise<JsonStore> {
    const retJson: JsonStore = {} as JsonStore;
    try {
      const prevTableName: string = this.tableName;
      retJson.database = this.dbName.slice(0, -9);
      retJson.encrypted = false;
      retJson.tables = [];
      // get the table list
      const tables: string[] = await this.tables();
      for (const table of tables) {
        this.tableName = table;
        const retTable: JsonTable = {} as JsonTable;
        retTable.name = table;
        retTable.values = [];
        const dataTable: Data[] = await this.keysvalues();
        for (const tdata of dataTable) {
          const retData: capDataStorageOptions = {} as capDataStorageOptions;
          retData.key = tdata.name;
          retData.value = tdata.value;
          retTable.values = [...retTable.values, retData];
        }
        retJson.tables = [...retJson.tables, retTable];
      }
      this.tableName = prevTableName;
      return Promise.resolve(retJson);
    } catch (err) {
      return Promise.reject(err);
    }
  }
}
