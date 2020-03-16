declare module "@capacitor/core" {
    interface PluginRegistry {
        CapacitorDataStorageSqlite: CapacitorDataStorageSqlitePlugin;
    }
}
export interface CapacitorDataStorageSqlitePlugin {
    echo(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
    /**
     * Open a store
     * @param {capOpenStorageOptions} options {database: string, table: string}
     * @returns {Promise<capDataStorageResult>} {result:boolean}
     */
    openStore(options: capOpenStorageOptions): Promise<capDataStorageResult>;
    /**
     * Set or Add a table to an existing store
     * @param {capOpenStorageOptions} options {table: string}
     * @returns {Promise<capDataStorageResult>} {result:boolean}
     */
    setTable(options: capOpenStorageOptions): Promise<capDataStorageResult>;
    /**
     * Store a data with given key and value
     * @param {capDataStorageOptions} options {key: string, value: string}
     * @returns {Promise<capDataStorageResult>} {result:boolean}
     */
    set(options: capDataStorageOptions): Promise<capDataStorageResult>;
    /**
     * Retrieve a data value for a given data key
     * @param {capDataStorageOptions} options {key:"foo",value:"foovalue"}
     * @returns {Promise<capDataStorageResult>} {value:string}
     */
    get(options: capDataStorageOptions): Promise<capDataStorageResult>;
    /**
     * Remove a data with given key
     * @param {capDataStorageOptions} options {key:"foo"}
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
     * @param {capDataStorageOptions} options {key:"foo"}
     * @returns {Promise<capDataStorageResult>} {result:boolean}
     */
    iskey(options: capDataStorageOptions): Promise<capDataStorageResult>;
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
    /**
     * Delete a store
     * @param {capOpenStorageOptions} options {database: string}
     * @returns {Promise<capDataStorageResult>} {result:boolean}
     */
    deleteStore(options: capOpenStorageOptions): Promise<capDataStorageResult>;
}
export interface capOpenStorageOptions {
    /**
     * The storage database name
     */
    database?: string;
    /**
     * The storage table name
     */
    table?: string;
    /**
     * Set to true for database encryption
     */
    encrypted?: boolean;
    /***
     * Set the mode for database ancryption
     * ["encryption", "secret","newsecret"]
     */
    mode?: string;
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
    /**
     * a message
     */
    message?: string;
}
