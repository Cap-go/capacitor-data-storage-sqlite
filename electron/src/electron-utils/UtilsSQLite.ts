//import * as sqlite3 from 'sqlite3';
//import * as path from 'path';
//import * as fs from 'fs';

//const sqlite3: any = window['sqlite3' as any];
////const fs: any = window['fs' as any];
//const path: any = window['path' as any];

export class UtilsSQLite {
  public pathDB: string = './DataStorage';
  Path: any = null;
  NodeFs: any = null;
  SQLite3: any = null;

  constructor() {
    this.Path = require('path');
    this.NodeFs = require('fs');
    this.SQLite3 = require('sqlite3');
  }
  public connection(dbName: string, readOnly?: boolean /*,key?:string*/): any {
    const flags = readOnly
      ? this.SQLite3.OPEN_READONLY
      : this.SQLite3.OPEN_CREATE | this.SQLite3.OPEN_READWRITE;
    console.log('in UtilsSQLite.connection flags ', flags);

    // get the path for the database
    const dbPath = this._getDBPath(dbName);
    console.log('#### dbPath ' + dbPath);
    let dbOpen: any;

    if (dbPath != null) {
      try {
        dbOpen = new this.SQLite3.Database(dbPath, flags);
        return dbOpen;
      } catch (e) {
        console.log('Error: in UtilsSQLite.connection ', e);
        return null;
      }
    }
  }

  public getWritableDatabase(dbName: string /*, secret: string*/): any {
    const db: any = this.connection(dbName, false /*,secret*/);
    return db;
  }

  public getReadableDatabase(dbName: string /*, secret: string*/): any {
    const db: any = this.connection(dbName, true /*,secret*/);
    return db;
  }
  private _getDBPath(dbName: string): string {
    let retPath: string = null;
    const dbFolder: string = this.pathDB;
    retPath = this.Path.join(dbFolder, dbName);

    try {
      if (!this.NodeFs.existsSync(dbFolder)) {
        this._mkdirSyncRecursive(dbFolder);
      }
    } catch (e) {
      console.log('Error: in getDBPath', e);
    }
    return retPath;
  }
  private _mkdirSyncRecursive(directory: string): void {
    var path = directory.replace(/\/$/, '').split('/');
    for (var i = 1; i <= path.length; i++) {
      var segment = path.slice(0, i).join('/');
      segment.length > 0 && !this.NodeFs.existsSync(segment)
        ? this.NodeFs.mkdirSync(segment)
        : null;
    }
    return;
  }
}
