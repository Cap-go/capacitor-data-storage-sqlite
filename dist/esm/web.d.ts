import { WebPlugin } from '@capacitor/core';
import { StorageDatabaseHelper } from './web-utils/StorageDatabaseHelper';
import { CapacitorDataStorageSqlitePlugin, capDataStorageOptions, capDataStorageResult, capOpenStorageOptions } from './definitions';
export declare class CapacitorDataStorageSqliteWeb extends WebPlugin implements CapacitorDataStorageSqlitePlugin {
    mDb: StorageDatabaseHelper;
    constructor();
    echo(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
    openStore(options: capOpenStorageOptions): Promise<capDataStorageResult>;
    setTable(options: capOpenStorageOptions): Promise<capDataStorageResult>;
    set(options: capDataStorageOptions): Promise<capDataStorageResult>;
    get(options: capDataStorageOptions): Promise<capDataStorageResult>;
    remove(options: capDataStorageOptions): Promise<capDataStorageResult>;
    clear(): Promise<capDataStorageResult>;
    iskey(options: capDataStorageOptions): Promise<capDataStorageResult>;
    keys(): Promise<capDataStorageResult>;
    values(): Promise<capDataStorageResult>;
    keysvalues(): Promise<capDataStorageResult>;
    deleteStore(options: capOpenStorageOptions): Promise<capDataStorageResult>;
}
declare const CapacitorDataStorageSqlite: CapacitorDataStorageSqliteWeb;
export { CapacitorDataStorageSqlite };
