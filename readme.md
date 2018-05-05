# ⚡️ Capacitor Data Storage SQLite Plugin
Capacitor Data Storage SQlite  Plugin is a custom Native Capacitor plugin to store permanently data to SQLite on IOS and Android platforms and to IndexDB for the Web platform.
As capacitor provides fisrt-class Progressive Web App support so you can use this plugin in your app which will later be deployed to the app stores and the mobile web.

## To use the Plugin in your Project
```bash
npm install --save capacitor-data-storage-sqlite@latest
```
*** warning *** 
As there is currently a misfunctionning of the Capacitor npm publish process for the IOS plugin, just after the installation you should open your favorite code editor and move the file ./node_modules/capacitor-data-storage-sqlite/ios/Plugin/CapacitorDataStorageSqlite.podspec to ./node_modules/capacitor-data-storage-sqlite/CapacitorDataStorageSqlite.podspec

Ionic App that shows an integration of [capacitor-data-storage-sqlite plugin](https://github.com/jepiqueau/ionic-capacitor-data-storage-sqlite)

## Limitations
The second release of the plugin includes the Native IOS code (Objective-C/Swift)  and the Native Android code (Java) using Capacitor v1.0.0-alpha.37

## Roadmap
    - Web with IndexDB

