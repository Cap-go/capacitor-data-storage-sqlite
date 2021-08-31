import { registerPlugin } from '@capacitor/core';
const CapacitorDataStorageSqlite = registerPlugin('CapacitorDataStorageSqlite', {
    web: () => import('./web').then(m => new m.CapacitorDataStorageSqliteWeb()),
    electron: () => window.CapacitorCustomPlatform.plugins
        .CapacitorDataStorageSqlite,
});
export * from './definitions';
export { CapacitorDataStorageSqlite };
//# sourceMappingURL=index.js.map