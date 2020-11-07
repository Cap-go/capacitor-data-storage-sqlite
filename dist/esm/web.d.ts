import { WebPlugin } from '@capacitor/core';
import { StorageDatabaseHelper } from './web-utils/StorageDatabaseHelper';
import { CapacitorDataStorageSqlitePlugin, capDataStorageOptions, capFilterStorageOptions, capOpenStorageOptions, capTableStorageOptions, capEchoOptions, capEchoResult, capDataStorageResult, capValueResult, capKeysResult, capValuesResult, capKeysValuesResult } from './definitions';
export declare class CapacitorDataStorageSqliteWeb extends WebPlugin implements CapacitorDataStorageSqlitePlugin {
    mDb: StorageDatabaseHelper;
    constructor();
    echo(options: capEchoOptions): Promise<capEchoResult>;
    openStore(options: capOpenStorageOptions): Promise<capDataStorageResult>;
    setTable(options: capTableStorageOptions): Promise<capDataStorageResult>;
    set(options: capDataStorageOptions): Promise<capDataStorageResult>;
    get(options: capDataStorageOptions): Promise<capValueResult>;
    remove(options: capDataStorageOptions): Promise<capDataStorageResult>;
    clear(): Promise<capDataStorageResult>;
    iskey(options: capDataStorageOptions): Promise<capDataStorageResult>;
    keys(): Promise<capKeysResult>;
    values(): Promise<capValuesResult>;
    filtervalues(options: capFilterStorageOptions): Promise<capValuesResult>;
    keysvalues(): Promise<capKeysValuesResult>;
    deleteStore(options: capOpenStorageOptions): Promise<capDataStorageResult>;
}
declare const CapacitorDataStorageSqlite: CapacitorDataStorageSqliteWeb;
export { CapacitorDataStorageSqlite };
