import { WebPlugin } from '@capacitor/core';

import type {
  CapacitorDataStorageSqlitePlugin,
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
  capValuesResult,
  capStorageOptions,
} from './definitions';

export class CapacitorDataStorageSqliteWeb
  extends WebPlugin
  implements CapacitorDataStorageSqlitePlugin {
  async echo(options: capEchoOptions): Promise<capEchoResult> {
    console.log('ECHO', options);
    const ret: capEchoResult = {} as capEchoResult;
    ret.value = options.value ? options.value : '';
    return ret;
  }

  async openStore(options: capOpenStorageOptions): Promise<void> {
    console.log('openStore', options);
    throw new Error('Method not implemented.');
  }
  async closeStore(options: capStorageOptions): Promise<void> {
    console.log('closeStore', options);
    throw new Error('Method not implemented.');
  }
  async isStoreOpen(options: capStorageOptions): Promise<capDataStorageResult> {
    console.log('isStoreOpen', options);
    throw new Error('Method not implemented.');
  }
  async isStoreExists(
    options: capStorageOptions,
  ): Promise<capDataStorageResult> {
    console.log('isStoreExists', options);
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
  async remove(options: capDataStorageOptions): Promise<void> {
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
  async filtervalues(
    options: capFilterStorageOptions,
  ): Promise<capValuesResult> {
    console.log('filtervalues', options);
    throw new Error('Method not implemented.');
  }
  async keysvalues(): Promise<capKeysValuesResult> {
    throw new Error('Method not implemented.');
  }
  async deleteStore(options: capOpenStorageOptions): Promise<void> {
    console.log('deleteStore', options);
    throw new Error('Method not implemented.');
  }
  async isTable(
    options: capTableStorageOptions,
  ): Promise<capDataStorageResult> {
    console.log('isTable', options);
    throw new Error('Method not implemented.');
  }
  async tables(): Promise<capKeysResult> {
    throw new Error('Method not implemented.');
  }
  async deleteTable(options: capTableStorageOptions): Promise<void> {
    console.log('deleteTable', options);
    throw new Error('Method not implemented.');
  }
}
