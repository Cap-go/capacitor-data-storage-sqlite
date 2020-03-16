//
//  StorageDatabaseHelper.swift
//  Plugin
//
//  Created by  Quéau Jean Pierre on 15/03/2020.
//  Copyright © 2020 Max Lynch. All rights reserved.
//

import Foundation

import SQLCipher

enum StorageDatabaseHelperError: Error {
    case creationTableFailed
    case creationIndexFailed
    case encryptionFailed
    case deleteFileFailed
    case fileNotExist
    case alreadyEncrypted
    case noTables
    case renameFileFailed
    case insertRowFailed
    case deleteStore
    case deleteDB
}

class StorageDatabaseHelper {
    public var isOpen: Bool = false;
    var tableName: String
    var secret: String
    var newsecret: String
    var encrypted: Bool
    var dbName: String
    let TABLE_INDEX:String = "sqlite_sequence"
    let IDX_COL_NAME: String = "name"
    let IDX_COL_SEQ: String = "seq"
    let COL_ID: String = "id"
    let COL_NAME: String = "name"
    let COL_VALUE: String = "value"
    // define the path for the database
    let path: String = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    // init function
    
    init(databaseName: String,tableName: String, encrypted:Bool, mode: String, secret:String = "", newsecret:String = "") throws {
        print("path: \(path)")
        self.tableName = tableName
        self.secret = secret
        self.newsecret = newsecret

        self.encrypted = encrypted
        self.dbName = databaseName

        // connect to the database (create if doesn't exist)
        var db: OpaquePointer?
        if !self.encrypted && mode == "no-encryption" {
            do {
                try db = UtilsSQLite.connection(filename: "\(path)/\(self.dbName)")
                self.isOpen = true
            } catch {
                let error:String = "init: Error Database connection failed"
                print(error)
                throw UtilsSQLiteError.connectionFailed
            }
        } else if encrypted && mode == "secret" && secret.count > 0 {
            do {
                try db = UtilsSQLite.connection(filename: "\(path)/\(self.dbName)",readonly: false,key: secret)
                self.isOpen = true
            } catch {
                let error:String = "init: Error Database connection failed wrong secret"
                print(error)
                self.isOpen = false
            }

        } else if encrypted && mode == "newsecret" && secret.count > 0 && newsecret.count > 0 {
            do {
                try db = UtilsSQLite.connection(filename: "\(path)/\(self.dbName)",readonly: false,key: secret)
                
                let keyStatementString = """
                PRAGMA rekey = '\(newsecret)';
                """
                if sqlite3_exec(db, keyStatementString, nil,nil,nil) != SQLITE_OK  {
                    print("connection: Unable to open a connection to database at \(path)/\(self.dbName)")
                    throw UtilsSQLiteError.wrongNewSecret
                }
                /* this should work but does not sqlite3_rekey_v2 is not known
                if sqlite3_rekey_v2(db!, "\(path)/\(self.dbName)", newsecret, Int32(newsecret.count)) == SQLITE_OK {
                    self.isOpen = true
                } else {
                    print("Unable to open a connection to database at \(path)/\(self.dbName)")
                    throw StorageDatabaseHelperError.wrongNewSecret
                }
                */
                self.secret = newsecret
                self.isOpen = true

            } catch {
                let error:String = "init: Error Database connection failed wrong secret"
                print(error)
                throw UtilsSQLiteError.wrongSecret
            }
        } else if encrypted && mode == "encryption" && secret.count > 0 {
            if UtilsSQLite.isFileExist(filePath: "\(path)/\(self.dbName)") {
                // rename database file as temp.db
                let tempFile: String = "\(path)/temp.db"
                try UtilsSQLite.renameFile(filePath: "\(path)/\(self.dbName)", toFilePath: tempFile)
                do {
                    try db = UtilsSQLite.connection(filename: "\(path)/\(self.dbName)",readonly: false,key: secret)
                    // copy the temp file in the new encrypted database
                    let tempDB: OpaquePointer = try UtilsSQLite.connection(filename: tempFile)
                    let tables: Array<String> = try getTables(db: tempDB)
                    let currentTableName: String = self.tableName
                    for table: String in tables {
                        self.tableName = table
                        let rawData: Array<Data> = getKeysValues(db: tempDB)!
                        // Create table
                        let res: Bool = createTable(db: db!,tableName: table, ifNotExists: false)
                        if res {
                            for row: Data in rawData {
                                let insertStatementString = "INSERT INTO \(table) (\(COL_NAME), \(COL_VALUE)) VALUES (?, ?);"
                                var insertStatement: OpaquePointer? = nil

                                if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                                    let name: NSString = row.name! as NSString
                                    let value: NSString = row.value! as NSString

                                    sqlite3_bind_text(insertStatement, 1, name.utf8String, -1, nil)
                                    sqlite3_bind_text(insertStatement, 2, value.utf8String, -1, nil)

                                  if sqlite3_step(insertStatement) != SQLITE_DONE {
                                    print("init: Could not insert row.")
                                    throw StorageDatabaseHelperError.insertRowFailed
                                  }
                                } else {
                                    print("init: INSERT statement could not be prepared.")
                                    throw StorageDatabaseHelperError.insertRowFailed
                                }
                                sqlite3_finalize(insertStatement)

                            }
                            // create index
                            let resIndex:Bool = createIndex(db:db!,tableName:table,colName:IDX_COL_NAME,ifNotExists:true);
                            if !resIndex {
                                throw StorageDatabaseHelperError.creationIndexFailed
                            }
                        } else {
                            throw StorageDatabaseHelperError.creationTableFailed
                        }
                    }
                    try _ = UtilsSQLite.deleteFile(fileName: "temp.db")
                    self.tableName = currentTableName
                    self.encrypted = true
                    self.isOpen = true

                } catch {
                    let error:String = "init: Error Database connection failed wrong secret"
                    print(error)
                    throw UtilsSQLiteError.wrongSecret
                }
            } else {
                let error:String = "init: Error Database not existing"
                print(error)
                throw StorageDatabaseHelperError.fileNotExist
            }
        }
        if(self.isOpen) {
            print("Successfully opened connection to database at \(path)/\(self.dbName)")

            // create table
            var res: Bool = createTable(db:db!,tableName:tableName,ifNotExists:true);
            if !res {
                throw StorageDatabaseHelperError.creationTableFailed
            }
            // create index
            res = createIndex(db:db!,tableName:tableName,colName:IDX_COL_NAME,ifNotExists:true);
            if !res {
                throw StorageDatabaseHelperError.creationIndexFailed
            }
        }
    }
    
    // Public function
    
    public func set(data:Data) -> Bool {
        var ret: Bool = false
        let db: OpaquePointer?
        do {
            try db = UtilsSQLite.getWritableDatabase(filename: "\(path)/\(self.dbName)",secret:self.secret)
        } catch let error {
            print("Error: \(error)")
            return false
        }
        // check if the data already exists
        if iskey(name: data.name!) {
            ret = updateData(data: data)
        } else {
            let insertStatementString = "INSERT INTO \(tableName) (\(COL_NAME), \(COL_VALUE)) VALUES (?, ?);"
            var insertStatement: OpaquePointer? = nil

            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                let name: NSString = data.name! as NSString
                let value: NSString = data.value! as NSString

                sqlite3_bind_text(insertStatement, 1, name.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, value.utf8String, -1, nil)

              if sqlite3_step(insertStatement) == SQLITE_DONE {
                 ret = true
              } else {
                print("set: Could not insert row.")
              }
            } else {
              print("set: INSERT statement could not be prepared.")
            }
            sqlite3_finalize(insertStatement)
        }
        return ret
    }
    public func get(name:String) -> Data? {
        var resArray: Array<Data> = []
        var retData: Data = Data()
        let db: OpaquePointer?
        do {
            try db = UtilsSQLite.getReadableDatabase(filename: "\(path)/\(self.dbName)",secret:self.secret)
        } catch let error {
           print("Error: \(error)")
           return nil
        }
        let getString: String = """
        SELECT * FROM \(tableName) WHERE \(COL_NAME) = "\(name)";
        """
        var getStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, getString, -1, &getStatement, nil) == SQLITE_OK {
            while (sqlite3_step(getStatement) == SQLITE_ROW ) {
                var rowData: Data = Data()
                rowData.id = Int64(sqlite3_column_int(getStatement, 0))
                let queryResultCol1 = sqlite3_column_text(getStatement, 1)
                rowData.name = String(cString: queryResultCol1!)
                let queryResultCol2 = sqlite3_column_text(getStatement, 2)
                rowData.value = String(cString: queryResultCol2!)
                resArray.append(rowData)
            }
        } else {
            print("get: Error statement could not be prepared.")
        }
        sqlite3_finalize(getStatement)
        if resArray.count > 0 {
            retData = resArray[0]
        } else {
            retData.id = nil
        }
        return retData
    }
    public func iskey(name:String) -> Bool {
        var ret: Bool = false
        // check if the key already exists
        if (get(name: name))!.id != nil {
            ret = true
        }
        return ret
    }
    public func updateData(data:Data) -> Bool {
        var ret: Bool = false
        let db: OpaquePointer?
        do {
            try db = UtilsSQLite.getWritableDatabase(filename: "\(path)/\(self.dbName)",secret:self.secret)
        } catch let error {
           print("Error: \(error)")
           return false
        }
        
        let updateStatementString = """
        UPDATE \(tableName) SET \(COL_VALUE) = ?
        WHERE \(COL_NAME) = ?;
        """
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            let name: NSString = data.name! as NSString
            let value: NSString = data.value! as NSString

            sqlite3_bind_text(updateStatement, 1, value.utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, name.utf8String, -1, nil)

          if sqlite3_step(updateStatement) == SQLITE_DONE {
             ret = true
          } else {
            print("updateData: Could not update row.")
          }
        } else {
          print("updateData: UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
        return ret
    }
    public func remove(name:String) -> Bool {
        var ret: Bool = false
        let db: OpaquePointer?
        do {
            try db = UtilsSQLite.getWritableDatabase(filename: "\(path)/\(self.dbName)",secret:self.secret)
        } catch let error {
           print("Error: \(error)")
           return false
        }
        let deleteStatementStirng = "DELETE FROM \(tableName) WHERE \(COL_NAME) = '\(name)';"
        
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
          if sqlite3_step(deleteStatement) == SQLITE_DONE {
            ret = true
          } else {
            print("remove: Could not delete row.")
          }
        } else {
          print("remove: DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
        return ret
    }
    public func clear() -> Bool {
        var ret: Bool = false
        let db: OpaquePointer?
        do {
            try db = UtilsSQLite.getWritableDatabase(filename: "\(path)/\(self.dbName)",secret:self.secret)
        } catch let error {
           print("Error: \(error)")
           return false
        }
        let deleteStatementStirng = "DELETE FROM \(tableName);"
        
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
          if sqlite3_step(deleteStatement) == SQLITE_DONE {
            ret = true
          } else {
            print("clear: Could not delete all rows.")
          }
        } else {
          print("clear: DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
        if ret {
            ret = resetIndex()
        }
        return ret
    }
    
    func setTable(tblName: String) -> Bool {
        var ret: Bool = false
        let db: OpaquePointer?
        do {
            try db = UtilsSQLite.getWritableDatabase(filename: "\(path)/\(self.dbName)",secret:self.secret)
        } catch let error {
            print("Error: \(error)")
            return false
        }
        let res: Bool = createTable(db:db!,tableName:tblName, ifNotExists: true);
        if res {
            tableName = tblName;
            // create index
            let resIndex: Bool = createIndex(db:db!,tableName:tableName,colName:IDX_COL_NAME,ifNotExists:true);
            if resIndex {
                ret = true
            }
        }
        return ret
    }
    
    func keys() -> Array<String>? {
        var retArray: Array<String> = Array<String>()
        let db: OpaquePointer?
        do {
            try db = UtilsSQLite.getReadableDatabase(filename: "\(path)/\(self.dbName)",secret:self.secret)
        } catch let error {
           print("Error: \(error)")
           return nil
        }
        let getKeysString: String = "SELECT * FROM \(tableName);"
        var getKeysStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, getKeysString, -1, &getKeysStatement, nil) == SQLITE_OK {
            while (sqlite3_step(getKeysStatement) == SQLITE_ROW ) {
                let queryResultCol1 = sqlite3_column_text(getKeysStatement, 1)
                retArray.append(String(cString: queryResultCol1!))
            }
        } else {
            print("getKeys: Error statement could not be prepared.")
        }
        sqlite3_finalize(getKeysStatement)
        return retArray
    }
    
    func values() -> Array<String>? {
        var retArray: Array<String> = Array<String>()
        let db: OpaquePointer?
        do {
            try db = UtilsSQLite.getReadableDatabase(filename: "\(path)/\(self.dbName)",secret:self.secret)
        } catch let error {
           print("Error: \(error)")
           return nil
        }
        let getValuesString: String = "SELECT * FROM \(tableName);"
        var getValuesStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, getValuesString, -1, &getValuesStatement, nil) == SQLITE_OK {
            while (sqlite3_step(getValuesStatement) == SQLITE_ROW ) {
                let queryResultCol2 = sqlite3_column_text(getValuesStatement, 2)
                retArray.append(String(cString: queryResultCol2!))
            }
        } else {
            print("getValues: Error statement could not be prepared.")
        }
        sqlite3_finalize(getValuesStatement)
        return retArray
    }
    
    func keysvalues() -> Array<Data>? {
        var retArray: Array<Data> = Array<Data>()
        let db: OpaquePointer?
        do {
            try db = UtilsSQLite.getReadableDatabase(filename: "\(path)/\(self.dbName)",secret:self.secret)
        } catch let error {
           print("Error: \(error)")
           return nil
        }
        retArray = getKeysValues(db: db)!
        return retArray
    }

    // Private functions

    private func createTable (db: OpaquePointer, tableName: String ,ifNotExists: Bool) -> Bool {
        var ret: Bool = false
        let exist: String = ifNotExists ? "IF NOT EXISTS" : ""
        let createTableString: String = """
        CREATE TABLE \(exist) \(tableName) (
        \(COL_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
        \(COL_NAME) TEXT NOT NULL UNIQUE,
        \(COL_VALUE) TEXT);
        """
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                ret = true
            } else {
                print("createTable: Error \(tableName) table could not be created.")
            }
        } else {
            print("createTable: Error CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
        
        return ret
    }
    private func createIndex(db: OpaquePointer, tableName: String, colName:String, ifNotExists: Bool) -> Bool {
        var ret: Bool = false
        let exist: String = ifNotExists ? "IF NOT EXISTS" : ""
        let idx: String = "index_\(tableName)_on_\(colName)"
        let createIndexString: String = """
        CREATE INDEX \(exist) "\(idx)" ON "\(tableName)" ("\(colName)");
        """
        var createIndexStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createIndexString, -1, &createIndexStatement, nil) == SQLITE_OK {
            if sqlite3_step(createIndexStatement) == SQLITE_DONE {
                ret = true
            } else {
                print("createIndex: Error Index \(idx) on table \(tableName) could not be created.")
            }
        } else {
            print("createIndex: Error CREATE INDEX statement could not be prepared.")
        }
        sqlite3_finalize(createIndexStatement)
        return ret
    }
    private func getTables(db:OpaquePointer) throws -> Array<String> {
        var retArray: Array<String> = Array<String>()

        let getTablesString: String = """
        SELECT * FROM sqlite_master WHERE TYPE="table";
        """
        var getTablesStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, getTablesString, -1, &getTablesStatement, nil) == SQLITE_OK {
            while (sqlite3_step(getTablesStatement) == SQLITE_ROW ) {
                let queryResultCol1 = sqlite3_column_text(getTablesStatement, 1)
                let name = String(cString: queryResultCol1!)
                if(name != "sqlite_sequence") {
                    retArray.append(name)
                }
            }
        } else {
            print("getTables: Error statement could not be prepared.")
        }
        sqlite3_finalize(getTablesStatement)
        if retArray.count > 0 {
            return retArray
        } else {
            throw StorageDatabaseHelperError.noTables
        }
    }

    private func resetIndex() -> Bool {
         var ret: Bool = false
         let db: OpaquePointer?
         do {
            try db = UtilsSQLite.getWritableDatabase(filename: "\(path)/\(self.dbName)",secret:self.secret)
         } catch let error {
            print("Error: \(error)")
            return false
         }
         let updateStatementString = "UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='\(tableName)';"
         var updateStatement: OpaquePointer? = nil
         if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
           if sqlite3_step(updateStatement) == SQLITE_DONE {
             ret = true
           } else {
             print("resetIndex: Could not reset Index.")
           }
         } else {
           print("resetIndex: UPDATE statement could not be prepared")
         }
         sqlite3_finalize(updateStatement)
         return ret
    }
    private func getKeysValues(db: OpaquePointer?) -> Array<Data>? {
        var retArray: Array<Data> = Array<Data>()
        let getKeysValuesString: String = "SELECT * FROM \(tableName);"
        var getKeysValuesStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, getKeysValuesString, -1, &getKeysValuesStatement, nil) == SQLITE_OK {
            while (sqlite3_step(getKeysValuesStatement) == SQLITE_ROW ) {
                var rowData: Data = Data()
                let queryResultCol1 = sqlite3_column_text(getKeysValuesStatement, 1)
                rowData.name = String(cString: queryResultCol1!)
                let queryResultCol2 = sqlite3_column_text(getKeysValuesStatement, 2)
                rowData.value = String(cString: queryResultCol2!)
                retArray.append(rowData)
            }
        } else {
            print("getKeysValues: Error statement could not be prepared.")
        }
        sqlite3_finalize(getKeysValuesStatement)
        return retArray

    }
    func deleteDB(databaseName:String) throws -> Bool {
        var ret: Bool = false
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            let fileURL = dir.appendingPathComponent(databaseName)
            let isFileExists = FileManager.default.fileExists(atPath: fileURL.path)
            if(isFileExists) {
                do {
                    try FileManager.default.removeItem(at: fileURL)
                    print("Database \(databaseName) deleted")
                    isOpen = false
                    ret = true
                } catch {
                    throw StorageDatabaseHelperError.deleteDB
                }
            } else {
                throw StorageDatabaseHelperError.deleteDB
            }
        }
        return ret
    }

}
