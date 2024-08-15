import { registerPlugin } from "@capacitor/core";

import type { CapgoCapacitorDataStorageSqlitePlugin } from "./definitions";

const CapgoCapacitorDataStorageSqlite =
  registerPlugin<CapgoCapacitorDataStorageSqlitePlugin>(
    "CapgoCapacitorDataStorageSqlite",
    {
      web: () =>
        import("./web").then((m) => new m.CapgoCapacitorDataStorageSqliteWeb()),
      electron: () =>
        (window as any).CapacitorCustomPlatform.plugins
          .CapacitorDataStorageSqlite,
    },
  );

export * from "./definitions";
export { CapgoCapacitorDataStorageSqlite };
