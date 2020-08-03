# API Documentation

Capacitor Data Storage SQlite Plugin provides a key-value store for simple data of `**type string only**`, so JSON object can be stored, you should manage conversion through JSON.stringify before storing and JSON.parse when retrieving the data, use the same procedure for number through number.toString() and Number().

For both IOS and Android platforms, the store can be encrypted. The plugin uses SQLCipher for encryption with a `**passphrase**`.

## Databases Location

### Android

    in **data/data/YOUR_PACKAGE/databases**

### IOS

    in **the Document folder of YOUR_APPLICATION**

### Electron

    in  **YourApplication/Electron/Databases**

## Methods available

### `openStore({}) => Promise<{result:boolean}>`

Open the store with default database and table names

#### Returns

Type: `Promise<{result:boolean}>`

### `openStore({database:"fooDB",table:"fooTable"}) => Promise<{result:boolean}>`

Open the store with given database and table names
the plugin add a suffix "SQLite" and an extension ".db" to the name given ie (fooDBSQLite.db)

#### Returns

Type: `Promise<{result:boolean}>`

### `setTable({table:"foo1Table"}) => Promise<{result:boolean,message?: string}>`

Set or add a table to an already opened store

#### Returns

Type: `Promise<{result:boolean,message?: string}>`

### `set({key:"foo",value:"foovalue"}) => Promise<{result:boolean,message?: string}>`

Set a key and its value in the store

#### Returns

Type: `Promise<{result:boolean,message?: string}>`

### `get({key:"foo"}) => Promise<{value:string}>`

Get the value of a given key from the store

#### Returns

Type: `Promise<{value:string}>`

### `iskey({key:"foo"}) => Promise<{result:boolean}>`

Check if a given key exists in the store

#### Returns

Type: `Promise<{result:boolean}>`

### `keys() => Promise<{keys:Array<string>}>`

Get all keys from the store

#### Returns

Type: `Promise<{keys:Array<string>}>`

### `values() => Promise<{values:Array<string>}>`

Get all values from the store

#### Returns

Type: `Promise<{values:Array<string>}>`

### `keysvalues() => Promise<{keysvalues:Array<{key:string,value:string}>}>`

Get all key/value pairs from the store

#### Returns

Type: `Promise<{keysvalues:Array<{key:string,value:string}>}>`

### `remove({key:"foo"}) => Promise<{result:boolean}>`

Remove a key from the store

#### Returns

Type: `Promise<{result:boolean}>`

### `clear() => Promise<{result:boolean}>`

Clear / Remove all keys from the store

#### Returns

Type: `Promise<{result:boolean}>`

## Methods available only for IOS and Android Plugins

### `deleteStore({}) => Promise<{result:boolean}>`

Delete the store with default database name

#### Returns

Type: `Promise<{result:boolean}>`

### `deleteStore({database:"fooDB"}) => Promise<{result:boolean}>`

Delete the store with given database name

#### Returns

Type: `Promise<{result:boolean}>`

## Methods available for encrypted database in IOS and Android

### `openStore({database:"fooDB",table:"fooTable",encrypted:true,mode:"encryption"}) => Promise<{result:boolean}>`

Encrypt an existing store with a secret key and open the store with given database and table names.

To define your own "secret" and "newsecret" keys:

- in IOS, go to the Pod/Development Pods/jeepqCapacitor/DataStorageSQLite/Global.swift file
- in Android, go to jeepq-capacitor/java/com.jeep.plugins.capacitor/cdssUtils/Global.java
  and update the default values before building your app.

#### Returns

Type: `Promise<{result:boolean}>`

### `openStore({database:"fooDB",table:"fooTable",encrypted:true,mode:"secret"}) => Promise<{result:boolean}>`

Open an encrypted store with given database and table names and secret key.

#### Returns

Type: `Promise<{result:boolean}>`

### `openStore({database:"fooDB",table:"fooTable",encrypted:true,mode:"newsecret"}) => Promise<{result:boolean}>`

Modify the secret key with the newsecret key of an encrypted store and open it with given database and table names and newsecret key.

#### Returns

Type: `Promise<{result:boolean}>`
