## 1.2.1-14 (2019-11-18)

### Bug Fixes

* fix README with Typescript wrapper class StorageAPIWrapper

## 1.2.1-13 (2019-11-17)

### Bug Fixes

* fix README 

## 1.2.1-12 (2019-11-17)

### Bug Fixes

* fix definition comments 
* add in README the use of a wrapper to conform to Storage API

## 1.2.1-11 (2019-11-14)

### Added Features

* add openStore to customize the database name and table name
* add setTable to add a new table or set an existing table to an opened store

## 1.2.1-10 (2019-11-08)

### Bug Fixes

* fix Firefox issue

## 1.2.1-4 (2019-10-06)

## 1.2.1-2 (2019-10-06)

### Bug Fixes

* fix(No available storage method found" error caused by INDEXEDDB on iOS web devices #9): Create a jeep-localforage module including the modification

### Bug Fixes

* fix(No available storage method found" error caused by INDEXEDDB on iOS web devices #9): The function isIndexedDBValid of localforage had to be modified and the fallback to LocalForage.WEBSQL had to be provided for Safari < 10.1

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

* capacitor: update to capacitor 1.2.1  


## 1.2.1 (2019-09-06)


### Chores

* capacitor: update to capacitor 1.2.0 