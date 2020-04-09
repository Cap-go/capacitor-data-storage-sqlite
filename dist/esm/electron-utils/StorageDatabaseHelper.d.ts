import { Data } from './Data';
export declare class StorageDatabaseHelper {
    private _db;
    private _dbName;
    private _tableName;
    private _utils;
    constructor();
    openStore(dbName: string, tableName: string): Promise<boolean>;
    private _createTable;
    private _createIndex;
    setTable(tableName: string): Promise<boolean>;
    set(data: Data): Promise<boolean>;
    get(name: string): Promise<Data>;
    update(data: Data): Promise<boolean>;
    iskey(name: string): Promise<boolean>;
    remove(name: string): Promise<boolean>;
    clear(): Promise<boolean>;
    keys(): Promise<Array<string>>;
    values(): Promise<Array<string>>;
    keysvalues(): Promise<Array<Data>>;
    deleteStore(dbName: string): Promise<boolean>;
}
