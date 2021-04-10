import { WebPlugin } from '@capacitor/core';
import type { CapacitorDataStorageSqlitePlugin, capEchoOptions, capEchoResult, capDataStorageOptions, capDataStorageResult, capFilterStorageOptions, capKeysResult, capKeysValuesResult, capOpenStorageOptions, capTableStorageOptions, capValueResult, capValuesResult } from './definitions';
export declare class CapacitorDataStorageSqliteWeb extends WebPlugin implements CapacitorDataStorageSqlitePlugin {
    echo(options: capEchoOptions): Promise<capEchoResult>;
    openStore(options: capOpenStorageOptions): Promise<void>;
    close(): Promise<void>;
    setTable(options: capTableStorageOptions): Promise<void>;
    set(options: capDataStorageOptions): Promise<void>;
    get(options: capDataStorageOptions): Promise<capValueResult>;
    remove(options: capDataStorageOptions): Promise<void>;
    clear(): Promise<void>;
    iskey(options: capDataStorageOptions): Promise<capDataStorageResult>;
    keys(): Promise<capKeysResult>;
    values(): Promise<capValuesResult>;
    filtervalues(options: capFilterStorageOptions): Promise<capValuesResult>;
    keysvalues(): Promise<capKeysValuesResult>;
    deleteStore(options: capOpenStorageOptions): Promise<void>;
    isTable(options: capTableStorageOptions): Promise<capDataStorageResult>;
    tables(): Promise<capKeysResult>;
    deleteTable(options: capTableStorageOptions): Promise<void>;
}
