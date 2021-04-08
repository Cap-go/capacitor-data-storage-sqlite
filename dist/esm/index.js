import { registerPlugin } from '@capacitor/core';
const CapacitorDataStorageSqlite = registerPlugin('CapacitorDataStorageSqlite', {
    web: () => import('./web').then(m => new m.CapacitorDataStorageSqliteWeb()),
});
export * from './definitions';
export { CapacitorDataStorageSqlite };
//# sourceMappingURL=index.js.map