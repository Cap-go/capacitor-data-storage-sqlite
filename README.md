 <a href="https://capgo.app/"><img src='https://raw.githubusercontent.com/Cap-go/capgo/main/assets/capgo_banner.png' alt='Capgo - Instant updates for capacitor'/></a>

<div align="center">
  <h2><a href="https://capgo.app/?ref=plugin"> ➡️ Get Instant updates for your App with Capgo 🚀</a></h2>
  <h2><a href="https://capgo.app/consulting/?ref=plugin"> Fix your annoying bug now, Hire a Capacitor expert 💪</a></h2>
</div>

<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h3 align="center">DATA STORAGE SQLITE</h3>
<p align="center"><strong><code>@capgo/capacitor-data-storage-sqlite</code></strong></p>
<br>
<p align="center" style="font-size:50px;color:red"><strong>CAPACITOR 6</strong></p><br>
<br>
<!-- Note from the Owner - Start -->
<p align="center" style="font-size:50px;color:red"><strong>Note from the Owner</strong></p>
<!-- Note from the Owner - End -->
<br>
<!-- Message below Note from the Owner - Start -->
<p align="left" style="font-size:47px">This Plugin has been transfered to Capgo org after his original creator <a href="https://github.com/jepiqueau">@jepiqueau</a> decide to retire. 
<br>We will forever be thankful for the work he did.</p>
<br>
<p align="center">
  Capacitor Data Storage SQlite Plugin is a custom Native Capacitor plugin providing a key-value permanent store for simple data of <strong>type string only</strong> to SQLite on IOS, Android and Electron platforms and to IndexDB for the Web platform.</p>

<p align="center">
  <img src="https://img.shields.io/maintenance/yes/2024?style=flat-square" />
  <a href="https://github.com/Cap-go/capacitor-data-storage-sqlite/actions?query=workflow%3A%22CI%22"><img src="https://img.shields.io/github/workflow/status/Cap-go/capacitor-data-storage-sqlite/CI?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/Cap-go/capacitor-data-storage-sqlite"><img src="https://img.shields.io/npm/l/capacitor-data-storage-sqlite.svg?style=flat-square" /></a>
<br>
  <a href="https://www.npmjs.com/package/Cap-go/capacitor-data-storage-sqlite"><img src="https://img.shields.io/npm/dw/capacitor-data-storage-sqlite?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/Cap-go/capacitor-data-storage-sqlite"><img src="https://img.shields.io/npm/v/capacitor-data-storage-sqlite?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
<a href="#contributors-"><img src="https://img.shields.io/badge/all%20contributors-4-orange?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:END -->
</p>

## Maintainers

| Maintainer        | GitHub                                    | Social |
| ----------------- | ----------------------------------------- | ------ |
| Martin Donadieu   | [riderx](https://github.com/riderx)       |        |
| Quéau Jean Pierre | [jepiqueau](https://github.com/jepiqueau) |        |

## Browser Support

The plugin follows the guidelines from the `Capacitor Team`,

- [Capacitor Browser Support](https://capacitorjs.com/docs/v3/web#browser-support)

meaning that it will not work in IE11 without additional JavaScript transformations, e.g. with [Babel](https://babeljs.io/).

## Installation

```bash
npm install --save @capgo/capacitor-data-storage-sqlite
npx cap sync
```

- On iOS, no further steps are needed.

- On Android, no further steps are needed.

- On Web, 
```bash
npm install --save localforage
```

- On Electron
```bash
npm install --save @capacitor-community/electron
npx cap add @capacitor-community/electron
```
Go to the Electron folder of your application

```bash
cd electron
npm install --save sqlite3
npm install --save-dev @types/sqlite3
npm run build
cd ..
npx cap sync @capacitor-community/electron
```

Then build YOUR_APPLICATION

```
npm run build
npx cap copy
npx cap copy @capacitor-community/electron
npx cap open ios
npx cap open android
npx cap open @capacitor-community/electron
ionic serve
```

## Configuration

No configuration required for this plugin

## Supported methods

| Name                         | Android | iOS | Electron | Web |
| :--------------------------- | :------ | :-- | :------- | :-- |
| openStore (non-encrypted DB) | ✅      | ✅  | ✅       | ✅  |
| openStore (encrypted DB)     | ✅      | ✅  | ❌       | ❌  |
| closeStore                   | ✅      | ✅  | ✅       | ❌  |
| isStoreOpen                  | ✅      | ✅  | ✅       | ❌  |
| isStoreExists                | ✅      | ✅  | ✅       | ❌  |
| deleteStore                  | ✅      | ✅  | ✅       | ❌  |
| setTable                     | ✅      | ✅  | ✅       | ✅  |
| set                          | ✅      | ✅  | ✅       | ✅  |
| get                          | ✅      | ✅  | ✅       | ✅  |
| iskey                        | ✅      | ✅  | ✅       | ✅  |
| keys                         | ✅      | ✅  | ✅       | ✅  |
| values                       | ✅      | ✅  | ✅       | ✅  |
| filtervalues                 | ✅      | ✅  | ✅       | ✅  |
| keysvalues                   | ✅      | ✅  | ✅       | ✅  |
| remove                       | ✅      | ✅  | ✅       | ✅  |
| clear                        | ✅      | ✅  | ✅       | ✅  |
| isTable                      | ✅      | ✅  | ✅       | ✅  |
| tables                       | ✅      | ✅  | ✅       | ✅  |
| deleteTable                  | ✅      | ✅  | ✅       | ❌  |
| isJsonValid                  | ✅      | ✅  | ✅       | ✅  |
| importFromJson               | ✅      | ✅  | ✅       | ✅  |
| exportToJson                 | ✅      | ✅  | ✅       | ✅  |

## Documentation

- [API_Documentation](docs/API.md)

- [USAGE_Documentation](docs/USAGE.md)

## Applications demonstrating the use of the plugin

### Ionic/Angular

- [angular-data-storage-sqlite-app-starter](https://github.com/Cap-go/angular-data-storage-sqlite-app-starter)

### Ionic/React

- [react-data-storage-sqlite-app-starter](https://github.com/Cap-go/react-data-storage-sqlite-app-starter)

### React

- [react-datastoragesqlite-app](https://github.com/Cap-go/react-datastoragesqlite-app)

### Ionic/Vue

- [vue-data-storage-sqlite-app-starter](https://github.com/Cap-go/vue-data-storage-sqlite-app-starter)

### Vue

- [vue-datastoragesqlite-app](https://github.com/Cap-go/vue-datastoragesqlite-app)

## Usage

- [see capacitor documentation](https://capacitor.ionicframework.com/docs/getting-started/with-ionic)

- [see USAGE_Documentation](https://github.com/Cap-go/capacitor-data-storage-sqlite/blob/master/docs/USAGE.md)

## Dependencies

The IOS & Android code use SQLCipher allowing for database encryption. 
The Android code is now based on `androidx.sqlite`. The database is not closed anymore after each transaction for performance improvement.
You must manage the `close` of the database before opening a new database.
The Web code use `localforage` package to store the datastore in the Browser.
The Electron code use `sqlite3`package

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/jepiqueau"><img src="https://avatars3.githubusercontent.com/u/16580653?v=4" width="100px;" alt=""/><br /><sub><b>Jean Pierre Quéau</b></sub></a><br /><a href="https://github.com/capacitor-data-storage-sqlite/commits?author=jepiqueau" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/mwpb"><img src="https://avatars.githubusercontent.com/u/12957941?v=4" width="100px;" alt=""/><br /><sub><b>Matthew Burke</b></sub></a><br /><a href="https://github.com/capacitor-data-storage-sqlite/commits?author=jepiqueau" title="Documentation">📖</a></td>    
    <td align="center"><a href="https://github.com/mwpb"><img src="https://avatars.githubusercontent.com/u/1745820?v=4" width="100px;" alt=""/><br /><sub><b>Kevin van Schaijk</b></sub></a><br /><a href="https://github.com/capacitor-data-storage-sqlite/commits?author=jepiqueau" title="Code">💻</a></td>  
    <td align="center"><a href="https://github.com/garbit"><img src="https://avatars.githubusercontent.com/u/555396?v=4" width="100px;" alt=""/><br /><sub><b>Andy Garbett</b></sub></a><br /><a href="https://github.com/capacitor-data-storage-sqlite/commits?author=jepiqueau" title="Documentation">📖</a></td>    
     
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->


<docgen-index>

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
* [`importFromJson(...)`](#importfromjson)
* [`isJsonValid(...)`](#isjsonvalid)
* [`exportToJson()`](#exporttojson)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

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


### importFromJson(...)

```typescript
importFromJson(options: capStoreImportOptions) => Promise<capDataStorageChanges>
```

Import a database From a JSON

| Param         | Type                                                                    |
| ------------- | ----------------------------------------------------------------------- |
| **`options`** | <code><a href="#capstoreimportoptions">capStoreImportOptions</a></code> |

**Returns:** <code>Promise&lt;<a href="#capdatastoragechanges">capDataStorageChanges</a>&gt;</code>

**Since:** 3.2.0

--------------------


### isJsonValid(...)

```typescript
isJsonValid(options: capStoreImportOptions) => Promise<capDataStorageResult>
```

Check the validity of a JSON Object

| Param         | Type                                                                    |
| ------------- | ----------------------------------------------------------------------- |
| **`options`** | <code><a href="#capstoreimportoptions">capStoreImportOptions</a></code> |

**Returns:** <code>Promise&lt;<a href="#capdatastorageresult">capDataStorageResult</a>&gt;</code>

**Since:** 3.2.0

--------------------


### exportToJson()

```typescript
exportToJson() => Promise<capStoreJson>
```

Export the given database to a JSON Object

**Returns:** <code>Promise&lt;<a href="#capstorejson">capStoreJson</a>&gt;</code>

**Since:** 3.2.0

--------------------


### Interfaces


#### capOpenStorageOptions

| Prop            | Type                 | Description                                                                 |
| --------------- | -------------------- | --------------------------------------------------------------------------- |
| **`database`**  | <code>string</code>  | The storage database name                                                   |
| **`table`**     | <code>string</code>  | The storage table name                                                      |
| **`encrypted`** | <code>boolean</code> | Set to true for database encryption                                         |
| **`mode`**      | <code>string</code>  | * Set the mode for database encryption ["encryption", "secret","newsecret"] |


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


#### capDataStorageChanges

| Prop          | Type                | Description                                          |
| ------------- | ------------------- | ---------------------------------------------------- |
| **`changes`** | <code>number</code> | the number of changes from an importFromJson command |


#### capStoreImportOptions

| Prop             | Type                | Description                   |
| ---------------- | ------------------- | ----------------------------- |
| **`jsonstring`** | <code>string</code> | Set the JSON object to import |


#### capStoreJson

| Prop         | Type                                            | Description           |
| ------------ | ----------------------------------------------- | --------------------- |
| **`export`** | <code><a href="#jsonstore">JsonStore</a></code> | an export JSON object |

| Method               | Signature                                    | Description                             |
| -------------------- | -------------------------------------------- | --------------------------------------- |
| **getPluginVersion** | () =&gt; Promise&lt;{ version: string; }&gt; | Get the native Capacitor plugin version |


#### JsonStore

| Prop            | Type                     | Description                                                  |
| --------------- | ------------------------ | ------------------------------------------------------------ |
| **`database`**  | <code>string</code>      | The database name                                            |
| **`encrypted`** | <code>boolean</code>     | Set to true (database encryption) / false iOS & Android only |
| **`tables`**    | <code>JsonTable[]</code> | * Array of Table (<a href="#jsontable">JsonTable</a>)        |


#### JsonTable

| Prop         | Type                                 | Description                                                                    |
| ------------ | ------------------------------------ | ------------------------------------------------------------------------------ |
| **`name`**   | <code>string</code>                  | The database name                                                              |
| **`values`** | <code>capDataStorageOptions[]</code> | * Array of Values (<a href="#capdatastorageoptions">capDataStorageOptions</a>) |

</docgen-api>

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

<p align="left" style="font-size:47px">Retirement message of @jepiqueau --></p>
<br>
<p align="left">
I have been dedicated to developing and maintaining this plugin for many years since the inception of Ionic Capacitor. Now, at 73+ years old, and with my MacBook Pro becoming obsolete for running Capacitor 6 for iOS, I have made the decision to cease maintenance of the plugin. If anyone wishes to take ownership of this plugin, they are welcome to do so.  
</p>
<br>
<p align="left">
It has been a great honor to be part of this development journey alongside the developer community. I am grateful to see many of you following me on this path and incorporating the plugin into your applications. Your comments and suggestions have motivated me to continuously improve it.  
</p>
<br>
<p align="left">
I have made this decision due to several family-related troubles that require my full attention and time. Therefore, I will not be stepping back. Thank you to all of you for your support.
</p>
<br>
<p align="left" style="font-size:47px">End <--</p>
<!-- Message below Note from the Owner - End -->
<br>

