<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h3 align="center">DATA STORAGE SQLITE</h3>
<p align="center"><strong><code>capacitor-data-storage-sqlite</code></strong></p>
<br>
<p align="center" style="font-size:50px;color:red"><strong>CAPACITOR 3 🚧</strong></p><br>
<p align="center">
  iOS & Android only</p>
<p align="center">
  Capacitor Data Storage SQlite Plugin is a custom Native Capacitor plugin providing a key-value permanent store for simple data of <strong>type string only</strong> to SQLite on IOS, Android and Electron platforms and to IndexDB for the Web platform.</p>

<p align="center">
  <img src="https://img.shields.io/maintenance/yes/2021?style=flat-square" />
  <a href="https://github.com/jepiqueau/capacitor-data-storage-sqlite/actions?query=workflow%3A%22CI%22"><img src="https://img.shields.io/github/workflow/status/jepiqueau/capacitor-data-storage-sqlite/CI?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/jepiqueau/capacitor-data-storage-sqlite"><img src="https://img.shields.io/npm/l/capacitor-data-storage-sqlite.svg?style=flat-square" /></a>
<br>
  <a href="https://www.npmjs.com/package/jepiqueau/capacitor-data-storage-sqlite"><img src="https://img.shields.io/npm/dw/capacitor-data-storage-sqlite?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/jepiqueau/capacitor-data-storage-sqlite"><img src="https://img.shields.io/npm/v/capacitor-data-storage-sqlite?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
<a href="#contributors-"><img src="https://img.shields.io/badge/all%20contributors-1-orange?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:END -->
</p>

## Maintainers

| Maintainer        | GitHub                                    | Social |
| ----------------- | ----------------------------------------- | ------ |
| Quéau Jean Pierre | [jepiqueau](https://github.com/jepiqueau) |        |

## Browser Support

The plugin follows the guidelines from the `Capacitor Team`,

- [Capacitor Browser Support](https://capacitorjs.com/docs/v3/web#browser-support)

meaning that it will not work in IE11 without additional JavaScript transformations, e.g. with [Babel](https://babeljs.io/).

## Installation

```bash
npm install capacitor-data-storage-sqlite@next
npx cap sync
```

- On iOS, no further steps are needed.

- On Android, no further steps are needed.

Then build YOUR_APPLICATION

```
npm run build
npx cap copy
npx cap open ios
npx cap open android
```

## Configuration

No configuration required for this plugin

## Supported methods

| Name                         | Android | iOS | Electron | Web |
| :--------------------------- | :------ | :-- | :------- | :-- |
| openStore (non-encrypted DB) | ✅      | ✅  | ❌       | ❌  |
| openStore (encrypted DB)     | ✅      | ✅  | ❌       | ❌  |
| close                        | ✅      | ❌  | ❌       | ❌  |
| setTable                     | ✅      | ✅  | ❌       | ❌  |
| set                          | ✅      | ✅  | ❌       | ❌  |
| get                          | ✅      | ✅  | ❌       | ❌  |
| iskey                        | ✅      | ✅  | ❌       | ❌  |
| keys                         | ✅      | ✅  | ❌       | ❌  |
| values                       | ✅      | ✅  | ❌       | ❌  |
| filtervalues                 | ✅      | ✅  | ❌       | ❌  |
| keysvalues                   | ✅      | ✅  | ❌       | ❌  |
| remove                       | ✅      | ✅  | ❌       | ❌  |
| clear                        | ✅      | ✅  | ❌       | ❌  |
| deleteStore                  | ✅      | ✅  | ❌       | ❌  |
| isTable                      | ✅      | ✅  | ❌       | ❌  |
| tables                       | ✅      | ✅  | ❌       | ❌  |
| deleteTable                  | ✅      | ✅  | ❌       | ❌  |

## Documentation

- [API_Documentation](https://github.com/jepiqueau/capacitor-data-storage-sqlite/blob/master/docs/API.md)

- [USAGE_Documentation](https://github.com/jepiqueau/capacitor-data-storage-sqlite/blob/master/docs/USAGE.md)

## Applications demonstrating the use of the plugin

### Ionic/Angular

- [angular-data-storage-sqlite-app-starter](https://github.com/jepiqueau/angular-data-storage-sqlite-app-starter)


### Ionic/React


### React


### Ionic/Vue


### Vue


## Usage

- [see capacitor documentation](https://capacitor.ionicframework.com/docs/getting-started/with-ionic)

- [see USAGE_Documentation](https://github.com/jepiqueau/capacitor-data-storage-sqlite/blob/master/docs/USAGE.md)

## Dependencies

The IOS & Android code use SQLCipher allowing for database encryption. 
The Android code is now based on `androidx.sqlite`. The database is not closed anymore after each transaction for performance improvement.
You must manage the `close`of the database before opening a new database.

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/jepiqueau"><img src="https://avatars3.githubusercontent.com/u/16580653?v=4" width="100px;" alt=""/><br /><sub><b>Jean Pierre Quéau</b></sub></a><br /><a href="https://github.com/capacitor-community/sqlite/commits?author=jepiqueau" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

