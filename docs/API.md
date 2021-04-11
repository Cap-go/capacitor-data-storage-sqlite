<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h2 align="center">API DOCUMENTATION</h2>
<p align="center"><strong><code>capacitor-data-storage-sqlite</code></strong></p>
<br>
<p align="center" style="font-size:50px;color:red"><strong>CAPACITOR 3 🚧</strong></p><br>
<p align="center">
  iOS for testing only</p>
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
* [`deleteStore(...)`](#deletestore)
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
echo(options: capEchoOptions) => any
```

| Param         | Type                                                      | Description                                    |
| ------------- | --------------------------------------------------------- | ---------------------------------------------- |
| **`options`** | <code><a href="#capechooptions">capEchoOptions</a></code> | : <a href="#capechooptions">capEchoOptions</a> |

**Returns:** <code>any</code>

**Since:** 0.0.1

--------------------


### openStore(...)

```typescript
openStore(options: capOpenStorageOptions) => any
```

Open a store

| Param         | Type                                                                    | Description                                                  |
| ------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------ |
| **`options`** | <code><a href="#capopenstorageoptions">capOpenStorageOptions</a></code> | : <a href="#capopenstorageoptions">capOpenStorageOptions</a> |

**Returns:** <code>any</code>

**Since:** 0.0.1

--------------------


### closeStore(...)

```typescript
closeStore(options: capStorageOptions) => any
```

Close the Store

| Param         | Type                                                            | Description                                          |
| ------------- | --------------------------------------------------------------- | ---------------------------------------------------- |
| **`options`** | <code><a href="#capstorageoptions">capStorageOptions</a></code> | : <a href="#capstorageoptions">capStorageOptions</a> |

**Returns:** <code>any</code>

**Since:** 3.0.0

--------------------


### isStoreOpen(...)

```typescript
isStoreOpen(options: capStorageOptions) => any
```

Check if the Store is opened

| Param         | Type                                                            | Description                                          |
| ------------- | --------------------------------------------------------------- | ---------------------------------------------------- |
| **`options`** | <code><a href="#capstorageoptions">capStorageOptions</a></code> | : <a href="#capstorageoptions">capStorageOptions</a> |

**Returns:** <code>any</code>

**Since:** 3.0.0

--------------------


### isStoreExists(...)

```typescript
isStoreExists(options: capStorageOptions) => any
```

Check if the Store exists

| Param         | Type                                                            | Description                                          |
| ------------- | --------------------------------------------------------------- | ---------------------------------------------------- |
| **`options`** | <code><a href="#capstorageoptions">capStorageOptions</a></code> | : <a href="#capstorageoptions">capStorageOptions</a> |

**Returns:** <code>any</code>

**Since:** 3.0.0

--------------------


### setTable(...)

```typescript
setTable(options: capTableStorageOptions) => any
```

Set or Add a table to an existing store

| Param         | Type                                                                      | Description                                                    |
| ------------- | ------------------------------------------------------------------------- | -------------------------------------------------------------- |
| **`options`** | <code><a href="#captablestorageoptions">capTableStorageOptions</a></code> | : <a href="#captablestorageoptions">capTableStorageOptions</a> |

**Returns:** <code>any</code>

**Since:** 0.0.1

--------------------


### set(...)

```typescript
set(options: capDataStorageOptions) => any
```

Store a data with given key and value

| Param         | Type                                                                    | Description                                                  |
| ------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------ |
| **`options`** | <code><a href="#capdatastorageoptions">capDataStorageOptions</a></code> | : <a href="#capdatastorageoptions">capDataStorageOptions</a> |

**Returns:** <code>any</code>

**Since:** 0.0.1

--------------------


### get(...)

```typescript
get(options: capDataStorageOptions) => any
```

Retrieve a data value for a given data key

| Param         | Type                                                                    | Description                                                  |
| ------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------ |
| **`options`** | <code><a href="#capdatastorageoptions">capDataStorageOptions</a></code> | : <a href="#capdatastorageoptions">capDataStorageOptions</a> |

**Returns:** <code>any</code>

**Since:** 0.0.1

--------------------


### remove(...)

```typescript
remove(options: capDataStorageOptions) => any
```

Remove a data with given key

| Param         | Type                                                                    | Description                                                  |
| ------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------ |
| **`options`** | <code><a href="#capdatastorageoptions">capDataStorageOptions</a></code> | : <a href="#capdatastorageoptions">capDataStorageOptions</a> |

**Returns:** <code>any</code>

**Since:** 0.0.1

--------------------


### clear()

```typescript
clear() => any
```

Clear the Data Store (delete all keys)

**Returns:** <code>any</code>

**Since:** 0.0.1

--------------------


### iskey(...)

```typescript
iskey(options: capDataStorageOptions) => any
```

Check if a data key exists

| Param         | Type                                                                    | Description                                                  |
| ------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------ |
| **`options`** | <code><a href="#capdatastorageoptions">capDataStorageOptions</a></code> | : <a href="#capdatastorageoptions">capDataStorageOptions</a> |

**Returns:** <code>any</code>

**Since:** 0.0.1

--------------------


### keys()

```typescript
keys() => any
```

Get the data key list

**Returns:** <code>any</code>

**Since:** 0.0.1

--------------------


### values()

```typescript
values() => any
```

Get the data value list

**Returns:** <code>any</code>

**Since:** 0.0.1

--------------------


### filtervalues(...)

```typescript
filtervalues(options: capFilterStorageOptions) => any
```

Get the data value list for filter keys

| Param         | Type                                                                        | Description                                                      |
| ------------- | --------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| **`options`** | <code><a href="#capfilterstorageoptions">capFilterStorageOptions</a></code> | : <a href="#capfilterstorageoptions">capFilterStorageOptions</a> |

**Returns:** <code>any</code>

**Since:** 2.4.2

--------------------


### keysvalues()

```typescript
keysvalues() => any
```

Get the data key/value pair list

**Returns:** <code>any</code>

**Since:** 0.0.1

--------------------


### deleteStore(...)

```typescript
deleteStore(options: capOpenStorageOptions) => any
```

Delete a store

| Param         | Type                                                                    | Description                                                  |
| ------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------ |
| **`options`** | <code><a href="#capopenstorageoptions">capOpenStorageOptions</a></code> | : <a href="#capopenstorageoptions">capOpenStorageOptions</a> |

**Returns:** <code>any</code>

**Since:** 0.0.1

--------------------


### isTable(...)

```typescript
isTable(options: capTableStorageOptions) => any
```

Check if a table exists

| Param         | Type                                                                      | Description                                                    |
| ------------- | ------------------------------------------------------------------------- | -------------------------------------------------------------- |
| **`options`** | <code><a href="#captablestorageoptions">capTableStorageOptions</a></code> | : <a href="#captablestorageoptions">capTableStorageOptions</a> |

**Returns:** <code>any</code>

**Since:** 3.0.0

--------------------


### tables()

```typescript
tables() => any
```

Get the table list for the current store

**Returns:** <code>any</code>

**Since:** 3.0.0

--------------------


### deleteTable(...)

```typescript
deleteTable(options: capTableStorageOptions) => any
```

Delete a store

| Param         | Type                                                                      | Description                                                    |
| ------------- | ------------------------------------------------------------------------- | -------------------------------------------------------------- |
| **`options`** | <code><a href="#captablestorageoptions">capTableStorageOptions</a></code> | : <a href="#captablestorageoptions">capTableStorageOptions</a> |

**Returns:** <code>any</code>

**Since:** 3.0.0

--------------------


### Interfaces


#### capEchoOptions

| Prop        | Type                | Description         |
| ----------- | ------------------- | ------------------- |
| **`value`** | <code>string</code> | String to be echoed |


#### capEchoResult

| Prop        | Type                | Description     |
| ----------- | ------------------- | --------------- |
| **`value`** | <code>string</code> | String returned |


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

| Prop       | Type            | Description                   |
| ---------- | --------------- | ----------------------------- |
| **`keys`** | <code>{}</code> | the data key list as an Array |


#### capValuesResult

| Prop         | Type            | Description                      |
| ------------ | --------------- | -------------------------------- |
| **`values`** | <code>{}</code> | the data values list as an Array |


#### capFilterStorageOptions

| Prop         | Type                | Description                                                                                                                     |
| ------------ | ------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **`filter`** | <code>string</code> | The filter data for filtering keys ['%filter', 'filter', 'filter%'] for [starts with filter, contains filter, ends with filter] |


#### capKeysValuesResult

| Prop             | Type            | Description                                                        |
| ---------------- | --------------- | ------------------------------------------------------------------ |
| **`keysvalues`** | <code>{}</code> | the data keys/values list as an Array of {key:string,value:string} |

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
