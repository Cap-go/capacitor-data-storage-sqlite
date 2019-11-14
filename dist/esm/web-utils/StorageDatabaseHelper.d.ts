import { Data } from "./Data";
export declare class StorageDatabaseHelper {
    private _db;
    private _dbName;
    constructor(dbName: string, tableName: string);
    openStore(dbName: string, tableName: string): boolean;
    setConfig(dbName: string, tableName: string): any;
    setTable(tableName: string): Promise<boolean>;
    set(data: Data): Promise<boolean>;
    get(name: string): Promise<Data>;
    remove(name: string): Promise<boolean>;
    clear(): Promise<boolean>;
    keys(): Promise<Array<string>>;
    values(): Promise<Array<string>>;
    keysvalues(): Promise<Array<Data>>;
    iskey(name: string): Promise<boolean>;
}
