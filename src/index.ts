import { registerPlugin } from '@capacitor/core';

import type { CapacitorDataStorageSqlitePlugin } from './definitions';

const CapacitorDataStorageSqlite = registerPlugin<CapacitorDataStorageSqlitePlugin>('CapacitorDataStorageSqlite', {
  web: () => import('./web').then((m) => new m.CapacitorDataStorageSqliteWeb()),
  electron: () => (window as any).CapacitorCustomPlatform.plugins.CapacitorDataStorageSqlite,
});

export * from './definitions';
export { CapacitorDataStorageSqlite };
