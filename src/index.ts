import { registerPlugin } from '@capacitor/core';

import type { CapacitorDataStorageSqlitePlugin } from './definitions';

const CapacitorDataStorageSqlite = registerPlugin<CapacitorDataStorageSqlitePlugin>(
  'CapacitorDataStorageSqlite',
  {
    web: () => import('./web').then(m => new m.CapacitorDataStorageSqliteWeb()),
  },
);

export * from './definitions';
export { CapacitorDataStorageSqlite };
