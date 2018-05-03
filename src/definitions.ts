declare global {
  interface PluginRegistry {
    CapacitorDataStorageSqlite?: CapacitorDataStorageSqlite;
  }
}

export interface CapacitorDataStorageSqlite {
  set(options: { key: string, value: string }): Promise<{result: boolean}>;
  get(options: { key: string}): Promise<{result: { value: string }}>;
  remove(options: {key:string}): Promise<{result: boolean}>;
  clear(): Promise<{result: boolean}>;
  iskey(options: {key:string}): Promise<{result: boolean}>;
  keys(): Promise<{keys: Array<string>}>;
  values(): Promise<{values: Array<string>}>;
  keysvalues(): Promise<{keysvalues: Array<any>}>;
}
