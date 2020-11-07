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
// swiftlint:disable type_body_length
// swiftlint:disable file_length
class StorageDatabaseHelper {
    var isOpen: Bool = false
    var tableName: String
    var secret: String
    var newsecret: String
    var encrypted: Bool
    var dbName: String
    var mode: String
    let TABLEINDEX: String = "sqlite_sequence"
    let IDXCOLNAME: String = "name"
    let IDXCOLSEQ: String = "seq"
    let COLID: String = "id"
    let COLNAME: String = "name"
    let COLVALUE: String = "value"
    // define the path for the database
    var path: String = ""

    // MARK: - Init

    init(databaseName: String, tableName: String, encrypted: Bool, mode: String,
         secret: String = "", newsecret: String = "") throws {
        print("path: \(path)")
        self.tableName = tableName
        self.secret = secret
        self.newsecret = newsecret
        self.mode = mode
        self.encrypted = encrypted
        self.dbName = databaseName
        do {
            self.path = try UtilsSQLite.getFilePath(fileName: databaseName)
        } catch UtilsSQLiteError.filePathFailed {
            print("init: Could not generate the file path")
        }
        if self.path.count > 0 {
        // connect to the database (create if doesn't exist)
            let connData: [String: String] = ["path": self.path, "mode": self.mode,
                "tablename": self.tableName, "idxcolname": IDXCOLNAME]
            let message: String =
                UtilsSQLite.createConnection(dbHelper: self, data: connData, encrypted: self.encrypted,
                                             secret: self.secret, newsecret: self.newsecret)
            self.isOpen = message.count == 0 || message == "swap newsecret" ||
                          message == "success encryption" ? true : false
            if message.count > 0 {
                if message.contains("connection:") {
                    throw UtilsSQLiteError.wrongNewSecret
                } else if message.contains("wrong secret") {
                    throw UtilsSQLiteError.wrongSecret
                } else if message == "swap newsecret" {
                    self.secret = self.newsecret
                } else if message == "success encryption" {
                    self.encrypted = true
                } else {
                    print("message")
                    throw UtilsSQLiteError.connectionFailed
                }
            }

        } else {
            print("init: Could not generate the store path")
        }
    }

    // MARK: - Set

    func set(data: Data) -> Bool {
        var ret: Bool = false
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getWritableDatabase(filename: self.path, secret: self.secret)
        } catch let error {
            print("set: \(error)")
            return false
        }
        // check if the data already exists
        guard let key: String = data.name else {
            print("set: Error no data.name given")
            return false
        }
        if isKeyExists(mDB: mDB, key: key) {
            ret = updateData(mDB: mDB, data: data)
        } else {
            let insertStatementString = "INSERT INTO \(tableName) (\(COLNAME), \(COLVALUE)) VALUES (?, ?);"
            var insertStatement: OpaquePointer?

            if sqlite3_prepare_v2(mDB, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                guard let name: NSString = data.name as NSString? else {
                    print("set: Could not find name.")
                    return false
                }
                guard let value: NSString = data.value as NSString? else {
                    print("set: Could not find value.")
                    return false
                }
                sqlite3_bind_text(insertStatement, 1, name.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, value.utf8String, -1, nil)

              if sqlite3_step(insertStatement) == SQLITE_DONE {
                 ret = true
              } else {
                print("set: Could not insert row.")
                return false
              }
            } else {
              print("set: INSERT statement could not be prepared.")
                return false
            }
            sqlite3_finalize(insertStatement)
        }
        closeDB(mDB: mDB, method: "set")
        return ret
    }

    // MARK: - Get

    func get(name: String) -> Data? {
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getReadableDatabase(filename: self.path, secret: self.secret)
        } catch let error {
           print("Error: \(error)")
           return nil
        }
        if let retData: Data = getValue(mDB: mDB, key: name) {
            closeDB(mDB: mDB, method: "get")
            return retData
        } else {
            closeDB(mDB: mDB, method: "get")
            return nil
        }
    }

    // MARK: - Iskey

    func iskey(name: String) -> Bool {
        var ret: Bool = false
        // check if the key already exists
        guard let data: Data = get(name: name) else {
            print("iskey: Error no data.name given")
            return false
        }
        if data.id != nil {
            ret = true
        }
        return ret
    }

    // MARK: - Remove

    func remove(name: String) -> Bool {
        var ret: Bool = false
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getWritableDatabase(filename: self.path, secret: self.secret)
        } catch let error {
           print("Error: \(error)")
           return false
        }
        let deleteStatementStirng = "DELETE FROM \(tableName) WHERE \(COLNAME) = '\(name)';"

        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
          if sqlite3_step(deleteStatement) == SQLITE_DONE {
            ret = true
          } else {
            print("remove: Could not delete row.")
          }
        } else {
          print("remove: DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
        closeDB(mDB: mDB, method: "remove")
        return ret
    }

    // MARK: - Clear

    func clear() -> Bool {
        var ret: Bool = false
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getWritableDatabase(filename: self.path, secret: self.secret)
        } catch let error {
           print("Error: \(error)")
           return false
        }
        let deleteStatementString = "DELETE FROM \(tableName);"

        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
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
        closeDB(mDB: mDB, method: "clear")
        return ret
    }

    // MARK: - SetTable

    func setTable(tblName: String) -> Bool {
        var ret: Bool = false
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getWritableDatabase(filename: self.path, secret: self.secret)
        } catch let error {
            print("Error: \(error)")
            return false
        }
        let res: Bool = createTable(mDB: mDB, tableName: tblName, ifNotExists: true)
        if res {
            tableName = tblName
            // create index
            let resIndex: Bool = createIndex(mDB: mDB, tableName: tableName, colName: IDXCOLNAME, ifNotExists: true)
            if resIndex {
                ret = true
            }
        }
        closeDB(mDB: mDB, method: "setTable")
        return ret
    }

    // MARK: - Keys

    func keys() -> [String] {
        var retArray: [String] = [String]()
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getReadableDatabase(filename: self.path, secret: self.secret)
        } catch let error {
            print("keys: \(error)")
            return [String]()
        }
        let getKeysString: String = "SELECT * FROM \(tableName);"
        var getKeysStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, getKeysString, -1, &getKeysStatement, nil) == SQLITE_OK {
            while sqlite3_step(getKeysStatement) == SQLITE_ROW {
                let queryResultCol1 = sqlite3_column_text(getKeysStatement, 1)
                if let mQueryResultCol1 = queryResultCol1 {
                    retArray.append(String(cString: mQueryResultCol1))
                } else {
                    print("keys: Error in sqlite3_column_text")
                    return [String]()
                }
            }
        } else {
            print("keys: Error statement could not be prepared.")
            return [String]()
        }
        sqlite3_finalize(getKeysStatement)
        closeDB(mDB: mDB, method: "keys")
        return retArray
    }

    // MARK: - Values

    func values() -> [String] {
        var retArray: [String] = [String]()
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getReadableDatabase(filename: self.path, secret: self.secret)
        } catch let error {
           print("values: \(error)")
           return [String]()
        }
        let getValuesString: String = "SELECT * FROM \(tableName);"
        var getValuesStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, getValuesString, -1, &getValuesStatement, nil) == SQLITE_OK {
            while sqlite3_step(getValuesStatement) == SQLITE_ROW {
                let queryResultCol2 = sqlite3_column_text(getValuesStatement, 2)
                if let mQueryResultCol2 = queryResultCol2 {
                    retArray.append(String(cString: mQueryResultCol2))
                } else {
                    print("values: Error in sqlite3_column_text")
                    return [String]()
                }
            }
        } else {
            print("values: Error statement could not be prepared.")
            return [String]()
        }
        sqlite3_finalize(getValuesStatement)
        closeDB(mDB: mDB, method: "values")
        return retArray
    }

    // MARK: - FilterValues

    func filtervalues(filter: String) -> [String] {
        var retArray: [String] = [String]()
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getReadableDatabase(filename: self.path, secret: self.secret)
        } catch let error {
           print("filtervalues: \(error)")
           return [String]()
        }
        var inFilter: String = filter
        if inFilter.prefix(1) != "%" && inFilter.suffix(1) != "%" {
            inFilter = "%" + inFilter + "%"
        }
        var getValuesString: String = "SELECT \(COLVALUE) FROM \(tableName) "
        getValuesString.append(" WHERE \(COLNAME) LIKE '\(inFilter)';")
        var getValuesStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, getValuesString, -1, &getValuesStatement, nil) == SQLITE_OK {
            while sqlite3_step(getValuesStatement) == SQLITE_ROW {
                let queryResultCol0 = sqlite3_column_text(getValuesStatement, 0)
                if let mQueryResultCol0 = queryResultCol0 {
                    retArray.append(String(cString: mQueryResultCol0))
                } else {
                    print("filtervalues: Error in sqlite3_column_text")
                    return [String]()
                }
            }
        } else {
            print("filtervalues: Error statement could not be prepared.")
            return [String]()
        }
        sqlite3_finalize(getValuesStatement)
        closeDB(mDB: mDB, method: "filtervalues")
        return retArray
    }

    // MARK: - KeysValues

    func keysvalues() -> [Data]? {
        var retArray: [Data] = [Data]()
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getReadableDatabase(filename: self.path, secret: self.secret)
        } catch let error {
           print("keysvalues: \(error)")
           return [Data]()
        }
        retArray = getKeysValues(mDB: mDB)
        closeDB(mDB: mDB, method: "keysvalues")
        return retArray
    }

    // MARK: - CloseDB

    func closeDB(mDB: OpaquePointer?, method: String) {
        var message: String = ""
        let returnCode: Int32 = sqlite3_close_v2(mDB)
        if returnCode != SQLITE_OK {
            let errmsg: String = String(cString: sqlite3_errmsg(mDB))
            message = "Error: \(method) closing the database rc: \(returnCode) message: \(errmsg)"
            print(message)
        }
    }

    // MARK: - CreateTable

    func createTable (mDB: OpaquePointer?, tableName: String, ifNotExists: Bool) -> Bool {
        var ret: Bool = false
        let exist: String = ifNotExists ? "IF NOT EXISTS" : ""
        let createTableString: String = """
        CREATE TABLE \(exist) \(tableName) (
        \(COLID) INTEGER PRIMARY KEY AUTOINCREMENT,
        \(COLNAME) TEXT NOT NULL UNIQUE,
        \(COLVALUE) TEXT);
        """
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
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

    // MARK: - CreateIndex

    func createIndex(mDB: OpaquePointer?, tableName: String, colName: String, ifNotExists: Bool) -> Bool {
        var ret: Bool = false
        let exist: String = ifNotExists ? "IF NOT EXISTS" : ""
        let idx: String = "index_\(tableName)_on_\(colName)"
        let createIndexString: String = """
        CREATE INDEX \(exist) "\(idx)" ON "\(tableName)" ("\(colName)");
        """
        var createIndexStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, createIndexString, -1, &createIndexStatement, nil) == SQLITE_OK {
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

    // MARK: - IsKeyExists

    private func isKeyExists(mDB: OpaquePointer?, key: String) -> Bool {
        var ret: Bool = false
        // check if the key already exists
        guard let data: Data = getValue(mDB: mDB, key: key) else {
            print("iskey: Error no data.name given")
            return false
        }
        if data.id != nil {
            ret = true
        }
        return ret
    }

    // MARK: - GetValue

    private func getValue(mDB: OpaquePointer?, key: String) -> Data? {
        var resArray: [Data] = []
        var retData: Data = Data()
        let getString: String = """
        SELECT * FROM \(tableName) WHERE \(COLNAME) = "\(key)";
        """
        var getStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, getString, -1, &getStatement, nil) == SQLITE_OK {
            while sqlite3_step(getStatement) == SQLITE_ROW {
                var rowData: Data = Data()
                rowData.id = Int64(sqlite3_column_int(getStatement, 0))
                let queryResultCol1 = sqlite3_column_text(getStatement, 1)
                if let mQueryResultCol1 = queryResultCol1 {
                    rowData.name = String(cString: mQueryResultCol1)
                } else {
                    print("get: Error in sqlite3_column_text column 1")
                    return nil
                }
                let queryResultCol2 = sqlite3_column_text(getStatement, 2)
                if let mQueryResultCol2 = queryResultCol2 {
                    rowData.value = String(cString: mQueryResultCol2)
                } else {
                    print("get: Error in sqlite3_column_text column 2")
                    return nil
                }
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

    // MARK: - UpdateData

    private func updateData(mDB: OpaquePointer?, data: Data) -> Bool {
        var ret: Bool = false

        let updateStatementString = """
        UPDATE \(tableName) SET \(COLVALUE) = ?
        WHERE \(COLNAME) = ?;
        """
        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            guard let name: NSString = data.name as NSString? else {
                print("updateData: Could not find name.")
                return false
            }
            guard let value: NSString = data.value as NSString? else {
                print("updateData: Could not find value.")
                return false
            }
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

    // MARK: - GetTables

    private func getTables(mDB: OpaquePointer?) throws -> [String] {
        var retArray: [String] = [String]()

        let getTablesString: String = """
        SELECT * FROM sqlite_master WHERE TYPE="table";
        """
        var getTablesStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, getTablesString, -1, &getTablesStatement, nil) == SQLITE_OK {
            while sqlite3_step(getTablesStatement) == SQLITE_ROW {
                let queryResultCol1 = sqlite3_column_text(getTablesStatement, 1)
                if let mQueryResultCol1 = queryResultCol1 {
                    let name = String(cString: mQueryResultCol1)
                    if name != "sqlite_sequence" {
                        retArray.append(name)
                    }
                } else {
                    print("get: Error in sqlite3_column_text column 1")
                    return [String]()
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

    // MARK: - ResetIndex

    private func resetIndex() -> Bool {
         var ret: Bool = false
         let mDB: OpaquePointer?
         do {
            try mDB = UtilsSQLite.getWritableDatabase(filename: self.path, secret: self.secret)
         } catch let error {
            print("Error: \(error)")
            return false
         }
         let updateStatementString = "UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='\(tableName)';"
         var updateStatement: OpaquePointer?
         if sqlite3_prepare_v2(mDB, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
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

    // MARK: - GetKeysValues

    private func getKeysValues(mDB: OpaquePointer?) -> [Data] {
        var retArray: [Data] = [Data]()
        let getKeysValuesString: String = "SELECT * FROM \(tableName);"
        var getKeysValuesStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, getKeysValuesString, -1, &getKeysValuesStatement, nil) == SQLITE_OK {
            while sqlite3_step(getKeysValuesStatement) == SQLITE_ROW {
                var rowData: Data = Data()
                let queryResultCol1 = sqlite3_column_text(getKeysValuesStatement, 1)
                if let mQueryResultCol1 = queryResultCol1 {
                    rowData.name = String(cString: mQueryResultCol1)
                } else {
                    print("get: Error in sqlite3_column_text column 1")
                    return [Data]()
                }
                let queryResultCol2 = sqlite3_column_text(getKeysValuesStatement, 2)
                if let mQueryResultCol2 = queryResultCol2 {
                    rowData.value = String(cString: mQueryResultCol2)
                } else {
                    print("get: Error in sqlite3_column_text column 2")
                    return [Data]()
                }
                retArray.append(rowData)
            }
            sqlite3_finalize(getKeysValuesStatement)
        } else {
            print("getKeysValues: Error statement could not be prepared.")
        }
        return retArray

    }

    // MARK: - DeleteDB

    func deleteDB(databaseName: String) throws -> Bool {
        var ret: Bool = false
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(databaseName)
            let isFileExists = FileManager.default.fileExists(atPath: fileURL.path)
            if isFileExists {
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
// swiftlint:enable type_body_length
// swiftlint:enable file_length
