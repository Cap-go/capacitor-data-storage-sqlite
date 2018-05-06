import { Data } from "../web-utils/data";
export declare class StorageDatabaseHelper {
    private _db;
    constructor();
    set(data: Data): Promise<boolean>;
    get(name: string): Promise<Data>;
    remove(name: string): Promise<boolean>;
    clear(): Promise<boolean>;
    keys(): Promise<Array<string>>;
    values(): Promise<Array<string>>;
    keysvalues(): Promise<Array<Data>>;
    iskey(name: string): Promise<boolean>;
}
