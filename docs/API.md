<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h2 align="center">API DOCUMENTATION</h2>
<p align="center"><strong><code>capacitor-data-storage-sqlite</code></strong></p>
<br>
<p align="center" style="font-size:50px;color:red"><strong>CAPACITOR 3</strong></p><br>

<p align="center">
  Capacitor Data Storage SQlite Plugin is a custom Native Capacitor plugin providing a key-value permanent store for simple data of <strong>type string only</strong> to SQLite on IOS, Android and Electron platforms and to IndexDB for the Web platform.</p>

To store `JSON object`, you should manage conversion through `JSON.stringify` before storing and `JSON.parse` when retrieving the data

To store `number`, use the same procedure, with `number.toString()` and `Number()`.

For both IOS and Android platforms, the store can be encrypted. The plugin uses SQLCipher for encryption with a `passphrase`.

## Databases Location

### Android

    in **data/data/YOUR_PACKAGE/databases**

### IOS

    in **the Document folder of YOUR_APPLICATION**

### Electron

    in  **YourApplication/Electron/Databases**

## Methods Index

<docgen-index>

* [`echo(...)`](#echo)
* [`openStore(...)`](#openstore)
* [`closeStore(...)`](#closestore)
* [`isStoreOpen(...)`](#isstoreopen)
* [`isStoreExists(...)`](#isstoreexists)
* [`deleteStore(...)`](#deletestore)
* [`setTable(...)`](#settable)
* [`set(...)`](#set)
* [`get(...)`](#get)
* [`remove(...)`](#remove)
* [`clear()`](#clear)
* [`iskey(...)`](#iskey)
* [`keys()`](#keys)
* [`values()`](#values)
* [`filtervalues(...)`](#filtervalues)
* [`keysvalues()`](#keysvalues)
* [`isTable(...)`](#istable)
* [`tables()`](#tables)
* [`deleteTable(...)`](#deletetable)
* [Interfaces](#interfaces)

</docgen-index>

## API

<docgen-api class="custom-css">
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: capEchoOptions) => Promise<capEchoResult>
```

| Param         | Type                                                      | Description                                    |
| ------------- | --------------------------------------------------------- | ---------------------------------------------- |
| **`options`** | <code><a href="#capechooptions">capEchoOptions</a></code> | : <a href="#capechooptions">capEchoOptions</a> |

**Returns:** <code>Promise&lt;<a href="#capechoresult">capEchoResult</a>&gt;</code>

**Since:** 0.0.1

--------------------


### openStore(...)

```typescript
openStore(options: capOpenStorageOptions) => Promise<void>
```

Open a store

| Param         | Type                                                                    | Description                                                  |
| ------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------ |
| **`options`** | <code><a href="#capopenstorageoptions">capOpenStorageOptions</a></code> | : <a href="#capopenstorageoptions">capOpenStorageOptions</a> |

**Since:** 0.0.1

--------------------


### closeStore(...)

```typescript
closeStore(options: capStorageOptions) => Promise<void>
```

Close the Store

| Param         | Type                                                            | Description                                          |
| ------------- | --------------------------------------------------------------- | ---------------------------------------------------- |
| **`options`** | <code><a href="#capstorageoptions">capStorageOptions</a></code> | : <a href="#capstorageoptions">capStorageOptions</a> |

**Since:** 3.0.0

--------------------


### isStoreOpen(...)

```typescript
isStoreOpen(options: capStorageOptions) => Promise<capDataStorageResult>
```

Check if the Store is opened

| Param         | Type                                                            | Description                                          |
| ------------- | --------------------------------------------------------------- | ---------------------------------------------------- |
| **`options`** | <code><a href="#capstorageoptions">capStorageOptions</a></code> | : <a href="#capstorageoptions">capStorageOptions</a> |

**Returns:** <code>Promise&lt;<a href="#capdatastorageresult">capDataStorageResult</a>&gt;</code>

**Since:** 3.0.0

--------------------


### isStoreExists(...)

```typescript
isStoreExists(options: capStorageOptions) => Promise<capDataStorageResult>
```

Check if the Store exists

| Param         | Type                                                            | Description                                          |
| ------------- | --------------------------------------------------------------- | ---------------------------------------------------- |
| **`options`** | <code><a href="#capstorageoptions">capStorageOptions</a></code> | : <a href="#capstorageoptions">capStorageOptions</a> |

**Returns:** <code>Promise&lt;<a href="#capdatastorageresult">capDataStorageResult</a>&gt;</code>

**Since:** 3.0.0

--------------------


### deleteStore(...)

```typescript
deleteStore(options: capOpenStorageOptions) => Promise<void>
```

Delete a store

| Param         | Type                                                                    | Description                                                  |
| ------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------ |
| **`options`** | <code><a href="#capopenstorageoptions">capOpenStorageOptions</a></code> | : <a href="#capopenstorageoptions">capOpenStorageOptions</a> |

**Since:** 0.0.1

--------------------


### setTable(...)

```typescript
setTable(options: capTableStorageOptions) => Promise<void>
```

Set or Add a table to an existing store

| Param         | Type                                                                      | Description                                                    |
| ------------- | ------------------------------------------------------------------------- | -------------------------------------------------------------- |
| **`options`** | <code><a href="#captablestorageoptions">capTableStorageOptions</a></code> | : <a href="#captablestorageoptions">capTableStorageOptions</a> |

**Since:** 0.0.1

--------------------


### set(...)

```typescript
set(options: capDataStorageOptions) => Promise<void>
```

Store a data with given key and value

| Param         | Type                                                                    | Description                                                  |
| ------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------ |
| **`options`** | <code><a href="#capdatastorageoptions">capDataStorageOptions</a></code> | : <a href="#capdatastorageoptions">capDataStorageOptions</a> |

**Since:** 0.0.1

--------------------


### get(...)

```typescript
get(options: capDataStorageOptions) => Promise<capValueResult>
```

Retrieve a data value for a given data key

| Param         | Type                                                                    | Description                                                  |
| ------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------ |
| **`options`** | <code><a href="#capdatastorageoptions">capDataStorageOptions</a></code> | : <a href="#capdatastorageoptions">capDataStorageOptions</a> |

**Returns:** <code>Promise&lt;<a href="#capvalueresult">capValueResult</a>&gt;</code>

**Since:** 0.0.1

--------------------


### remove(...)

```typescript
remove(options: capDataStorageOptions) => Promise<void>
```

Remove a data with given key

| Param         | Type                                                                    | Description                                                  |
| ------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------ |
| **`options`** | <code><a href="#capdatastorageoptions">capDataStorageOptions</a></code> | : <a href="#capdatastorageoptions">capDataStorageOptions</a> |

**Since:** 0.0.1

--------------------


### clear()

```typescript
clear() => Promise<void>
```

Clear the Data Store (delete all keys)

**Since:** 0.0.1

--------------------


### iskey(...)

```typescript
iskey(options: capDataStorageOptions) => Promise<capDataStorageResult>
```

Check if a data key exists

| Param         | Type                                                                    | Description                                                  |
| ------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------ |
| **`options`** | <code><a href="#capdatastorageoptions">capDataStorageOptions</a></code> | : <a href="#capdatastorageoptions">capDataStorageOptions</a> |

**Returns:** <code>Promise&lt;<a href="#capdatastorageresult">capDataStorageResult</a>&gt;</code>

**Since:** 0.0.1

--------------------


### keys()

```typescript
keys() => Promise<capKeysResult>
```

Get the data key list

**Returns:** <code>Promise&lt;<a href="#capkeysresult">capKeysResult</a>&gt;</code>

**Since:** 0.0.1

--------------------


### values()

```typescript
values() => Promise<capValuesResult>
```

Get the data value list

**Returns:** <code>Promise&lt;<a href="#capvaluesresult">capValuesResult</a>&gt;</code>

**Since:** 0.0.1

--------------------


### filtervalues(...)

```typescript
filtervalues(options: capFilterStorageOptions) => Promise<capValuesResult>
```

Get the data value list for filter keys

| Param         | Type                                                                        | Description                                                      |
| ------------- | --------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| **`options`** | <code><a href="#capfilterstorageoptions">capFilterStorageOptions</a></code> | : <a href="#capfilterstorageoptions">capFilterStorageOptions</a> |

**Returns:** <code>Promise&lt;<a href="#capvaluesresult">capValuesResult</a>&gt;</code>

**Since:** 2.4.2

--------------------


### keysvalues()

```typescript
keysvalues() => Promise<capKeysValuesResult>
```

Get the data key/value pair list

**Returns:** <code>Promise&lt;<a href="#capkeysvaluesresult">capKeysValuesResult</a>&gt;</code>

**Since:** 0.0.1

--------------------


### isTable(...)

```typescript
isTable(options: capTableStorageOptions) => Promise<capDataStorageResult>
```

Check if a table exists

| Param         | Type                                                                      | Description                                                    |
| ------------- | ------------------------------------------------------------------------- | -------------------------------------------------------------- |
| **`options`** | <code><a href="#captablestorageoptions">capTableStorageOptions</a></code> | : <a href="#captablestorageoptions">capTableStorageOptions</a> |

**Returns:** <code>Promise&lt;<a href="#capdatastorageresult">capDataStorageResult</a>&gt;</code>

**Since:** 3.0.0

--------------------


### tables()

```typescript
tables() => Promise<capTablesResult>
```

Get the table list for the current store

**Returns:** <code>Promise&lt;<a href="#captablesresult">capTablesResult</a>&gt;</code>

**Since:** 3.0.0

--------------------


### deleteTable(...)

```typescript
deleteTable(options: capTableStorageOptions) => Promise<void>
```

Delete a table

| Param         | Type                                                                      | Description                                                    |
| ------------- | ------------------------------------------------------------------------- | -------------------------------------------------------------- |
| **`options`** | <code><a href="#captablestorageoptions">capTableStorageOptions</a></code> | : <a href="#captablestorageoptions">capTableStorageOptions</a> |

**Since:** 3.0.0

--------------------


### Interfaces


#### capEchoResult

| Prop        | Type                | Description     |
| ----------- | ------------------- | --------------- |
| **`value`** | <code>string</code> | String returned |


#### capEchoOptions

| Prop        | Type                | Description         |
| ----------- | ------------------- | ------------------- |
| **`value`** | <code>string</code> | String to be echoed |


#### capOpenStorageOptions

| Prop            | Type                 | Description                                                                 |
| --------------- | -------------------- | --------------------------------------------------------------------------- |
| **`database`**  | <code>string</code>  | The storage database name                                                   |
| **`table`**     | <code>string</code>  | The storage table name                                                      |
| **`encrypted`** | <code>boolean</code> | Set to true for database encryption                                         |
| **`mode`**      | <code>string</code>  | * Set the mode for database ancryption ["encryption", "secret","newsecret"] |


#### capStorageOptions

| Prop           | Type                | Description      |
| -------------- | ------------------- | ---------------- |
| **`database`** | <code>string</code> | The storage name |


#### capDataStorageResult

| Prop          | Type                 | Description                                   |
| ------------- | -------------------- | --------------------------------------------- |
| **`result`**  | <code>boolean</code> | result set to true when successful else false |
| **`message`** | <code>string</code>  | a returned message                            |


#### capTableStorageOptions

| Prop        | Type                | Description            |
| ----------- | ------------------- | ---------------------- |
| **`table`** | <code>string</code> | The storage table name |


#### capDataStorageOptions

| Prop        | Type                | Description                  |
| ----------- | ------------------- | ---------------------------- |
| **`key`**   | <code>string</code> | The data name                |
| **`value`** | <code>string</code> | The data value when required |


#### capValueResult

| Prop        | Type                | Description                         |
| ----------- | ------------------- | ----------------------------------- |
| **`value`** | <code>string</code> | the data value for a given data key |


#### capKeysResult

| Prop       | Type                  | Description                   |
| ---------- | --------------------- | ----------------------------- |
| **`keys`** | <code>string[]</code> | the data key list as an Array |


#### capValuesResult

| Prop         | Type                  | Description                      |
| ------------ | --------------------- | -------------------------------- |
| **`values`** | <code>string[]</code> | the data values list as an Array |


#### capFilterStorageOptions

| Prop         | Type                | Description                                                                                                                     |
| ------------ | ------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **`filter`** | <code>string</code> | The filter data for filtering keys ['%filter', 'filter', 'filter%'] for [starts with filter, contains filter, ends with filter] |


#### capKeysValuesResult

| Prop             | Type               | Description                                                        |
| ---------------- | ------------------ | ------------------------------------------------------------------ |
| **`keysvalues`** | <code>any[]</code> | the data keys/values list as an Array of {key:string,value:string} |


#### capTablesResult

| Prop         | Type                  | Description                 |
| ------------ | --------------------- | --------------------------- |
| **`tables`** | <code>string[]</code> | the tables list as an Array |

</docgen-api>

## Encrypted DataStore

### Existing Datastore encryption

use the `openStore` method with the following options:

```
{
    database:"fooDB",
    table:"fooTable",
    encrypted:true,
    mode:"encryption"
}
```

The existing datastore will be encrypted with a secret key and opens with given database and table names.

To define your own "secret" and "newsecret" keys:

- in IOS, go to the Pod/Development Pods/jeepqCapacitor/DataStorageSQLite/Global.swift file
- in Android, go to jeepq-capacitor/java/com.jeep.plugins.capacitor/cdssUtils/Global.java

and then update the default values before building your app.

### Create a New Encrypted Datastore

use the `openStore` method with the following options:

```
{
    database:"fooDB",
    table:"fooTable",
    encrypted:true,
    mode:"secret"
}
```

The Datastore will be encrypted and opens with given database and table names and the secret key stored in your application.

### Change the Secret of an Existing Encrypted Datastore

use the `openStore` method with the following options:

```
{
    database:"fooDB",
    table:"fooTable",
    encrypted:true,
    mode:"newsecret"
}
```

The secret key of the encrypted datastore will be modified with the newsecret key stored in your application and the datastore will be opened with given database and table names and newsecret key.

Do not forget after this change of secret to go in the code of your app and modified in the `Global`file the `secret` paramater with the value of the `newsecret` parameter and reassign a new value of your choice to the `newsecret` parameter, before the relauch of your app.
