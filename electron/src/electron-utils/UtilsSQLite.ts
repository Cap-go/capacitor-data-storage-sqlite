export class UtilsSQLite {
  public pathDB = "./DataStorage";
  Path: any = null;
  NodeFs: any = null;
  SQLite3: any = null;

  constructor() {
    this.Path = require("path");
    this.NodeFs = require("fs");
    this.SQLite3 = require("sqlite3");
  }
  public async connection(
    dbName: string,
    readOnly?: boolean,
    /*,key?:string*/
  ): Promise<any> {
    const flags = readOnly
      ? this.SQLite3.OPEN_READONLY
      : this.SQLite3.OPEN_CREATE | this.SQLite3.OPEN_READWRITE;

    // get the path for the database
    try {
      const dbPath = await this.getDBPath(dbName);
      const dbOpen = new this.SQLite3.Database(dbPath, flags);
      return Promise.resolve(dbOpen);
    } catch (err) {
      return Promise.reject(err);
    }
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
  public isFileExists(dbName: string): Promise<boolean> {
    const dbFolder: string = this.pathDB;
    const path = this.Path.join(dbFolder, dbName);
    let ret = false;
    try {
      if (this.NodeFs.existsSync(path)) {
        ret = true;
      }
      return Promise.resolve(ret);
    } catch (err) {
      return Promise.reject(err);
    }
  }
  private async getDBPath(dbName: string): Promise<string> {
    let retPath: string = null;
    const dbFolder: string = this.pathDB;
    retPath = this.Path.join(dbFolder, dbName);

    try {
      if (!this.NodeFs.existsSync(dbFolder)) {
        await this.mkdirSyncRecursive(dbFolder);
      }
      return Promise.resolve(retPath);
    } catch (err) {
      return Promise.reject(err);
    }
  }
  private async mkdirSyncRecursive(directory: string): Promise<void> {
    const path = directory.replace(/\/$/, "").split("/");
    for (let i = 1; i <= path.length; i++) {
      const segment = path.slice(0, i).join("/");
      segment.length > 0 && !this.NodeFs.existsSync(segment)
        ? this.NodeFs.mkdirSync(segment)
        : null;
    }
    return;
  }
}
