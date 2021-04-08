import { WebPlugin } from '@capacitor/core';

import type { CapacitorDataStorageSqlitePlugin,
              capEchoOptions, 
              capEchoResult,
              capDataStorageOptions,
              capDataStorageResult,
              capFilterStorageOptions,
              capKeysResult,
              capKeysValuesResult,
              capOpenStorageOptions,
              capTableStorageOptions,
              capValueResult,
              capValuesResult } from './definitions';

export class CapacitorDataStorageSqliteWeb
  extends WebPlugin
  implements CapacitorDataStorageSqlitePlugin {

  async echo(options: capEchoOptions): Promise<capEchoResult> {
    console.log('ECHO', options);
    const ret: capEchoResult = {} as capEchoResult;
    ret.value = options.value ? options.value : "";
    return ret;
  }
  
  async openStore(options: capOpenStorageOptions): Promise<void> {
    console.log('openStore', options);
    throw new Error('Method not implemented.');
  }
  async setTable(options: capTableStorageOptions): Promise<void> {
    console.log('setTable', options);
    throw new Error('Method not implemented.');
  }
  async set(options: capDataStorageOptions): Promise<void> {
    console.log('set', options);
    throw new Error('Method not implemented.');
  }
  async get(options: capDataStorageOptions): Promise<capValueResult> {
    console.log('get', options);
    throw new Error('Method not implemented.');
  }
  async remove(options: capDataStorageOptions): Promise<capDataStorageResult> {
    console.log('remove', options);
    throw new Error('Method not implemented.');
  }
  async clear(): Promise<void> {
    throw new Error('Method not implemented.');
  }
  async iskey(options: capDataStorageOptions): Promise<capDataStorageResult> {
    console.log('iskey', options);
    throw new Error('Method not implemented.');
  }
  async keys(): Promise<capKeysResult> {
    throw new Error('Method not implemented.');
  }
  async values(): Promise<capValuesResult> {
    throw new Error('Method not implemented.');
  }
  async filtervalues(options: capFilterStorageOptions): Promise<capValuesResult> {
    console.log('filtervalues', options);
    throw new Error('Method not implemented.');
  }
  async keysvalues(): Promise<capKeysValuesResult> {
    throw new Error('Method not implemented.');
  }
  async deleteStore(options: capOpenStorageOptions): Promise<capDataStorageResult> {
    console.log('deleteStore', options);
    throw new Error('Method not implemented.');
  }
}
