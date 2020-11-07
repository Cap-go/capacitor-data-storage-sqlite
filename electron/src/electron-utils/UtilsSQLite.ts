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
  public connection(
    dbName: string,
    readOnly?: boolean,
    /*,key?:string*/
  ): Promise<any> {
    return new Promise(async resolve => {
      const flags = readOnly
        ? this.SQLite3.OPEN_READONLY
        : this.SQLite3.OPEN_CREATE | this.SQLite3.OPEN_READWRITE;

      // get the path for the database
      const dbPath = await this._getDBPath(dbName);
      let dbOpen: any;

      if (dbPath != null) {
        try {
          dbOpen = new this.SQLite3.Database(dbPath, flags);
          resolve(dbOpen);
        } catch (e) {
          console.log('Error: in UtilsSQLite.connection ', e);
          resolve(null);
        }
      }
    });
  }

  public async getWritableDatabase(
    dbName: string,
    /*, secret: string*/
  ): Promise<any> {
    const db: any = await this.connection(dbName, false /*,secret*/);
    return db;
  }

  public async getReadableDatabase(
    dbName: string,
    /*, secret: string*/
  ): Promise<any> {
    const db: any = await this.connection(dbName, true /*,secret*/);
    return db;
  }
  private async _getDBPath(dbName: string): Promise<string> {
    let retPath: string = null;
    const dbFolder: string = this.pathDB;
    retPath = this.Path.join(dbFolder, dbName);

    try {
      if (!this.NodeFs.existsSync(dbFolder)) {
        await this._mkdirSyncRecursive(dbFolder);
      }
    } catch (e) {
      console.log('Error: in getDBPath', e);
    }
    return retPath;
  }
  private async _mkdirSyncRecursive(directory: string): Promise<void> {
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
