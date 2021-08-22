## 3.2.0-1 (2021-08-22)

### Chore

- @capacitor/core 3.2.0
- @capacitor-community/electron 3.1.0

### Added Features (Electron)

- split the whole code as originately

## 3.1.2-3 (2021-08-05)

### Bug Fixes

- fix Debug logs in distribution build issue#48

## 3.1.2-2 (2021-07-16)

### Bug Fixes

- fix verify all platforms (build)

## 3.1.2-1 (2021-07-16)

### Bug Fixes

- fix invalid error during update for existing key on iOS #47
- update README, CHANGELOG

## 3.1.1 (2021-07-13)

### Chore

- @capacitor/core 3.1.1

## 3.0.2 (2021-07-06)

### Chore

- @capacitor/core 3.0.2
- Electron 13.1.4

### Bug Fixes

- fix Android Upgrade and single quotes in data make sqlite inserts fail. issue#45

## 3.0.1 (2021-06-09)

### Bug Fixes

- fix iOS get

## 3.0.0 (2021-06-07)

### Bug Fixes

- fix iOS isStoreExists, isStoreOpen

## 3.0.0-rc.4 (2021-06-07)

### Bug Fixes

- fix files electron in package.json

## 3.0.0-rc.3 (2021-06-07)

### Chore

- Electron 12.0.8

### Added Features (Electron)

- rewrite the whole code to try...catch error


## 3.0.0-rc.2 (2021-06-04)

### Bug Fixes

- fix CapacitorDataStorageSqlite.podspec

## 3.0.0-rc.1 (2021-06-04) Not to be used

### Chores

- capacitor: update to capacitor 3.0.0

### Added Features (Web)

- rewrite the whole code to try...catch error


## 3.0.0-alpha.7 (2021-05-11)

### Chores

- capacitor: update to capacitor 3.0.0-rc.2

## 3.0.0-alpha.6 (2021-04-12)

### Bug Fixes

- fix closeStore iOS

## 3.0.0-alpha.5 (2021-04-12)

### Added Features (iOS)

- rewrite the whole code to remove the closeDB at each transaction

## 3.0.0-alpha.4 (2021-04-11)

### Added Features (Android)

- add isStoreOpen, isStoreExists, deleteStore
- rename close in closeStore

### Bug Fixes

- fix encryption issue

## 3.0.0-alpha.3 (2021-04-10)

### Added Features (Android)

- add all methods
- add close method (Android only)

## 3.0.0-alpha.2 (2021-04-09)

### Added Features (iOS)

- isTable, tables, deleteTable

## 3.0.0-alpha.1 (2021-04-08)

### Added Features (iOS)

- USAGE.md documentation
- isKey, keys, values, keysvalues
- filtervalues, deleteStore

### Bug Fixes

- fix CapacitorDataStorageSqlite.podspec

## 3.0.0-alpha.0 (2021-04-08)

### Chores

- capacitor: update to capacitor 3.0.0-rc.0

## 2.4.7 (2021-04-04)

### Chores

- capacitor: update to capacitor 2.4.7

## 2.4.5 (2021-01-06)

### Chores

- capacitor: update to capacitor 2.4.5

### Bug Fixes

- Fix issue#34 by adding chapter ## Browser Support in the readme file

## 2.4.2 (2020-11-07)

### Added Features

- add filtervalues to get all values for filter keys
- add Ionic/Vue app starter
- add Vue app demonstrating the use of the plugin in Vue3.0
- add USAGE documentation

### Bug Fixes

- Fix issue#28
- Clean the readme file
- Clean the API documentation

## 2.4.2-2 (2020-10-27)

### Bug Fixes

- Fix issue#31 in Electron

## 2.4.2-1 (2020-10-02)

### Chores

- capacitor: update to capacitor 2.4.2

### ### Added Features

- The electron plugin is now compatible with @capacitor-community/electron

## 2.3.0 (2020-08-05)

### Bug Fixes

- Fix the CHANGELOG.md

## 2.3.0-beta.2 (2020-08-05)

### Bug Fixes

- Fix the CHANGELOG.md

## 2.3.0-beta.1 (2020-08-04)

### Bug Fixes

- Fix all changes required to pass lint and swiftlint

## 2.3.0-1 (2020-07-27)

### Chores

- capacitor: update to capacitor 2.3.0

## 2.2.0 (2020-06-26)

### Chores

- capacitor: update to capacitor 2.2.0

## 2.1.0 (2020-05-14)

### Chores

- capacitor: update to capacitor 2.1.0
- SQLCipher: update to 4.4.0

## 2.0.0-1 (2020-04-09)

### Chores

- capacitor: update to capacitor 2.0.0
- android: update to androidX

### Added Features

- add a .gitignore file

## 1.5.3 (2020-04-06)

### Added Features

- Add Electron Plugin based on sqlite3. Works only for non-encrypted datastores

## 1.5.2 (2020-04-01)

### Chores

- capacitor: update to capacitor 1.5.2

## 1.5.2-1 (2020-03-18)

### Bug Fixes

- Fix Cursor not close in Android plugin

## 1.5.1 (2020-03-17)

### Bug Fixes

- update README link to applications

## 1.5.1-2 (2020-03-15)

### Bug Fixes

- fix table not created in Android pluginwhen opening the same store with a new table name

## 1.5.1-1 (2020-03-15)

### Added Features

- Undeprecating the npm package to allow user to load only this capacitor plugin in there applications (advise by the Ionic Capacitor team)

## 1.4.0-dev.7 (2020-01-08)

### Bug Fixes

- typo in readme found by rjayaswal

## 1.4.0-dev.6 (2019-12-30)

### Added Features

- set the secret natively in OPS and Android

## 1.4.0-dev.5 (2019-12-28)

### Added Features

- add encrypted database for IOS

### Bug Fixes

- fix Android encrypted database for Android

## 1.4.0-dev.4 (2019-12-25)

### Added Features

- add encrypted database for Android Only

## 1.2.1-14 (2019-11-18)

### Bug Fixes

- fix README with Typescript wrapper class StorageAPIWrapper

## 1.2.1-13 (2019-11-17)

### Bug Fixes

- fix README

## 1.2.1-12 (2019-11-17)

### Bug Fixes

- fix definition comments
- add in README the use of a wrapper to conform to Storage API

## 1.2.1-11 (2019-11-14)

### Added Features

- add openStore to customize the database name and table name
- add setTable to add a new table or set an existing table to an opened store

## 1.2.1-10 (2019-11-08)

### Bug Fixes

- fix Firefox issue

## 1.2.1-4 (2019-10-06)

## 1.2.1-2 (2019-10-06)

### Bug Fixes

- fix(No available storage method found" error caused by INDEXEDDB on iOS web devices #9): Create a jeep-localforage module including the modification

### Bug Fixes

- fix(No available storage method found" error caused by INDEXEDDB on iOS web devices #9): The function isIndexedDBValid of localforage had to be modified and the fallback to LocalForage.WEBSQL had to be provided for Safari < 10.1

```
        var retValue = false;
        var isApple =  /(Macintosh|iPhone|iPad|iPod)/.test(navigator.userAgent);
        if( isApple) {
            var isSafari = typeof openDatabase !== 'undefined' && /(Safari|iPhone|iPad|iPod)/.test(navigator.userAgent) && !/Chrome/.test(navigator.userAgent) && !/BlackBerry/.test(navigator.platform) && !/Android/.test(navigator.userAgent);
            var isVersion = /(Version)/.test(navigator.userAgent);
            if(isSafari && isVersion) {
                var versionString = navigator.userAgent.substring(navigator.userAgent.indexOf('Version/'));
                versionString = versionString.substring(0,versionString.indexOf(' ')).replace('Version/','');
                var versionArray = versionString.split('.');
                var version = Number(versionArray[0]);
                var subversion = versionArray.length > 1 ? Number(versionArray[1]) : -1;
                if((version === 10 && subversion >= 1) || version > 10)  {
                    retValue = true;
                }
            } else {
                retValue = !isSafari && typeof indexedDB !== 'undefined' && typeof IDBKeyRange !== 'undefined';
            }
        } else {
            if ( typeof openDatabase !== 'undefined' && typeof indexedDB !== 'undefined' && typeof IDBKeyRange !== 'undefined') {
                retValue  = true;
            }
        }
        return retValue;

```

## 1.2.1-1 (2019-10-06)

### Chores

- capacitor: update to capacitor 1.2.1

## 1.2.1 (2019-09-06)

### Chores

- capacitor: update to capacitor 1.2.0
