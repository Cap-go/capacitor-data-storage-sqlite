import { registerPlugin } from "@capacitor/core";
const CapgoCapacitorDataStorageSqlite = registerPlugin("CapgoCapacitorDataStorageSqlite", {
    web: () => import("./web").then((m) => new m.CapgoCapacitorDataStorageSqliteWeb()),
    electron: () => window.CapacitorCustomPlatform.plugins
        .CapacitorDataStorageSqlite,
});
export * from "./definitions";
export { CapgoCapacitorDataStorageSqlite };
//# sourceMappingURL=index.js.map