# Capacitor Data Storage SQLite Plugin
Capacitor Data Storage SQlite  Plugin is a custom Native Capacitor plugin to store permanently data to SQLite on IOS and Android platforms and to IndexDB for the Web platform.
As capacitor provides fisrt-class Progressive Web App support so you can use this plugin in your app which will later be deployed to the app stores and the mobile web.

Capacitor Data Storage SQlite Plugin provides a key-value store for simple data of type string only, so JSON object can be stored, you should manage conversion through JSON.stringify before storing and JSON.parse when retrieving the data, use the same procedure for number through number.toString() and Number().

## Methods available

    clear()                             clear the store
    get({key:"foo"})                    get a value given the key           
    iskey({key:"foo"})                  test key exists
    keys()                              get all keys
    keysvalues()                        get all key/value pairs
    remove({key:"foo"})                 remove a key
    set({key:"foo",value:"foovalue"})   set key and its value
    values()                            get all values

## To use the Plugin in your Project
```bash
npm install --save capacitor-data-storage-sqlite@latest
```

Ionic App that shows an integration of [capacitor-data-storage-sqlite plugin](https://github.com/jepiqueau/ionic-capacitor-data-storage-sqlite)

## Limitations
The second release of the plugin includes the Native IOS code (Objective-C/Swift)  and the Native Android code (Java) using Capacitor v1.0.0-alpha.37

## Roadmap
    - Web with IndexDB

