<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h2 align="center">JSON Import/Export DOCUMENTATION</h2>
<p align="center"><strong><code>capacitor-data-storage-sqlite</code></strong></p>
<br>
<p align="center" style="font-size:50px;color:red"><strong>CAPACITOR 3</strong></p><br>

<p align="center">
  Capacitor Data Storage SQlite Plugin is a custom Native Capacitor plugin providing a key-value permanent store for simple data of <strong>type string only</strong> to SQLite on IOS, Android and Electron platforms and to IndexDB for the Web platform.</p>

## Index

- [`Methods`](#methods)
  - [`Import From JSON`](#importfromjson)
  - [`Export To JSON`](#exporttojson)
  - [`Is JSON Valid`](#isjsonvalid)
  - [`Json Object`](#json-object)
  - [`JSON Template Examples`](#json-template-examples)

## Methods


### importFromJson

This method allow to create a database from a JSON Object.
The created database can be encrypted or not based on the value of the name **_encrypted_**" of the JSON Object.

### exportToJson

This method allow to download a database to a Json object.

### isJsonValid

this method allow to check if the Json Object is valid before processing an import or validating the resulting Json Object from an export.

## JSON Object

The JSON object is built up using the following types


```js
export type jsonStore = {
  database: string,
  encrypted: boolean,
  tables: Array<jsonTable>,
};
export type jsonTable = {
  name: string,
  values?: Array<jsonValue>,
};
export type jsonValue = {
  key: string,
  value: string
};
```

## JSON Template Examples

```js
const jsonData1 = {
  database: "testImport",
  encrypted: false,
  tables: [
    {
      name: "myStore1",
      values: [
        {key: "test1", value: "my first test"},
        {key: "test2", value: JSON.stringify({a: 10, b: 'my second test', c:{k:'hello',l: 15}})},
      ]
    },
    {
      name: "myStore2",
      values: [
        {key: "test1", value: "my first test in store2"},
        {key: "test2", value: JSON.stringify({a: 20, b: 'my second test in store2 ', d:{k:'hello',l: 15}})},
        {key: "test3", value: "100"},
      ]
    },
  ]
}
```
