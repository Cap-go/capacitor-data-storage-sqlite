declare global {
  interface PluginRegistry {
    CapacitorDataStorageSqlite?: CapacitorDataStorageSqlite;
  }
}

export interface CapacitorDataStorageSqlite {
  saveData(options: { name: string, value: string }): Promise<{result: boolean}>;
  getData(options: { name: string}): Promise<{result: { value: string }}>;
  removeData(options: {name:string}): Promise<{result: boolean}>;
  removeAllData(): Promise<{result: boolean}>;
}
