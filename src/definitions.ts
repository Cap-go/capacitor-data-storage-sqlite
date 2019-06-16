declare module "@capacitor/core" {
  interface PluginRegistry {
    CapacitorDataStorageSqlite: CapacitorDataStorageSqlitePlugin;
  }
}

export interface CapacitorDataStorageSqlitePlugin {
  /**
   * Store a data with given key and value
   * @param {capDataStorageOptions} options 
   * @returns {Promise<capDataStorageResult>} {result:boolean}
   */
  set(options: capDataStorageOptions): Promise<capDataStorageResult>;
  /**
   * Retrieve a data value for a given data key
   * @param {capDataStorageOptions} options 
   * @returns {Promise<capDataStorageResult>} {value:string}
   */
  get(options: capDataStorageOptions): Promise<capDataStorageResult>;
  /**
   * Remove a data with given key
   * @param {capDataStorageOptions} options 
   * @returns {Promise<capDataStorageResult>} {result:boolean}
   */
  remove(options: capDataStorageOptions): Promise<capDataStorageResult>;
  /**
   * Clear the Data Store (delete all keys)
   * @returns {Promise<capDataStorageResult>} {result:boolean}
   */
  clear(): Promise<capDataStorageResult>;
  /**
   * Check if a data key exists
   * @param {capDataStorageOptions} options 
   * @returns {Promise<capDataStorageResult>} {result:boolean}
   */
  iskey(options: capDataStorageOptions): Promise<capDataStorageResult>;
  remove(options: capDataStorageOptions): Promise<capDataStorageResult>;
  /**
   * Get the data key list
   * @returns {Promise<capDataStorageResult>} {keys:Array<string>}
   */
  keys(): Promise<capDataStorageResult>;
  /**
   * Get the data value list
   * @returns {Promise<capDataStorageResult>} {values:Array<string>}
   */
  values(): Promise<capDataStorageResult>;
  /**
   * Get the data key/value pair list
   * @returns {Promise<capDataStorageResult>} {keysvalues:Array<{key:string,value:string}>}
   */
  keysvalues(): Promise<capDataStorageResult>;
}

export interface capDataStorageOptions {
  /**
   * The data name
   */
  key: string;
  /**
   * The data value when required
   */
  value?: string;
}

export interface capDataStorageResult {
  /**
   * result set to true when successful else false
   */
  result?: boolean;
  /**
   * the data value for a given data key
   */
  value?: string;
  /**
   * the data key list as an Array
   */
  keys?: Array<string>;
  /**
   * the data values list as an Array
   */
  values?: Array<string>;
  /**
   * the data keys/values list as an Array of {key:string,value:string}
   */
  keysvalues?: Array<any>;
}
