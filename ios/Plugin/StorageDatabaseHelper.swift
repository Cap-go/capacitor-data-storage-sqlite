//
//  StorageDatabaseHelper.swift
//  Plugin
//
//  Created by  Quéau Jean Pierre on 08/04/2021.
//  Copyright © 2021 Max Lynch. All rights reserved.
//

import Foundation
import SQLCipher

enum StorageHelperError: Error {
    case initFailed(message: String)
    case setTable(message: String)
    case creationTable(message: String)
    case creationIndex(message: String)
    case setkey(message: String)
    case getkey(message: String)
    case iskey(message: String)
    case remove(message: String)
    case clear(message: String)
    case isKeyExists(message: String)
    case insertData(message: String)
    case updateData(message: String)
    case closeDB(message: String)
    case getValue(message: String)
    case resetIndex(message: String)
    case keys(message: String)
    case values(message: String)
    case filtervalues(message: String)
    case keysvalues(message: String)
    case getKeysValues(message: String)
    case getTables(message: String)
    case encryptionFailed
    case deleteFileFailed
    case fileNotExist
    case alreadyEncrypted
    case noTables
    case renameFileFailed
    case insertRowFailed
    case deleteStore
    case deleteDB(message: String)
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

    // swiftlint:disable function_body_length
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
            let msg = "Could not generate the file path"
            throw StorageHelperError.initFailed(message: msg)
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
                    let msg = "wrong new secret"
                    throw StorageHelperError
                    .initFailed(message: msg)
                } else if message.contains("wrong secret") {
                    let msg = "wrong secret"
                    throw StorageHelperError
                    .initFailed(message: msg)
                } else if message == "swap newsecret" {
                    self.secret = self.newsecret
                } else if message == "success encryption" {
                    self.encrypted = true
                } else {
                    print("message")
                    throw StorageHelperError
                    .initFailed(message: message)
                }
            }

        } else {
            let msg = "Could not generate the store path"
            throw StorageHelperError
            .initFailed(message: msg)
        }
    }

    // MARK: - Set

    func set(data: Data) throws {
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite
                .getWritableDatabase(filename: self.path,
                                     secret: self.secret)
        } catch let error {
            let msg = error.localizedDescription
            throw StorageHelperError.setkey(message: msg)
        }
        // check if the data already exists
        guard let key: String = data.name else {
            let msg = "no data.name given"
            throw StorageHelperError.setkey(message: msg)
        }
        do {

            let isKey = try isKeyExists(mDB: mDB, key: key)
            if isKey {
                try updateData(mDB: mDB, data: data)
            } else {
                try insertData(mDB: mDB, data: data)
            }
            try closeDB(mDB: mDB, method: "set")

        } catch StorageHelperError.isKeyExists(let message) {
            throw StorageHelperError.setkey(message: message)
        } catch StorageHelperError.insertData(let message) {
            throw StorageHelperError.setkey(message: message)
        } catch StorageHelperError.updateData(let message) {
            throw StorageHelperError.setkey(message: message)
        } catch StorageHelperError.closeDB(let message) {
            throw StorageHelperError.setkey(message: message)
        } catch let error {
            let msg = error.localizedDescription
            throw StorageHelperError.setkey(message: msg)
        }
    }

    // MARK: - Get

    func get(name: String) throws -> Data? {
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getReadableDatabase(filename: self.path,
                                                      secret: self.secret)
            if let retData: Data = try getValue(mDB: mDB, key: name) {
                try closeDB(mDB: mDB, method: "get")
                return retData
            } else {
                try closeDB(mDB: mDB, method: "get")
                return nil
            }
        } catch StorageHelperError.getValue(let message) {
            throw StorageHelperError.getkey(message: message)
        } catch StorageHelperError.closeDB(let message) {
            throw StorageHelperError.getkey(message: message)
        } catch let error {
            let msg = error.localizedDescription
            throw StorageHelperError.getkey(message: msg)
        }

    }

    // MARK: - Iskey

    func iskey(name: String) throws -> Bool {
        var ret: Bool = false
        // check if the key already exists
        guard let data: Data = try get(name: name) else {
            let msg = "Error no data.name given"
            throw StorageHelperError.iskey(message: msg)
        }
        if data.id != nil {
            ret = true
        }
        return ret
    }

    // MARK: - Remove

    func remove(name: String) throws {
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getWritableDatabase(filename: self.path,
                                                      secret: self.secret)
            let deleteStatementStirng = "DELETE FROM \(tableName) WHERE " +
                "\(COLNAME) = '\(name)';"
            var deleteStatement: OpaquePointer?
            if sqlite3_prepare_v2(mDB, deleteStatementStirng, -1, &deleteStatement,
                                  nil) == SQLITE_OK {
                if sqlite3_step(deleteStatement) != SQLITE_DONE {
                    let msg = "Could not delete row."
                    throw StorageHelperError.remove(message: msg)
                }
            } else {
                let msg = "DELETE statement could not be prepared."
                throw StorageHelperError.remove(message: msg)
            }
            sqlite3_finalize(deleteStatement)
            try closeDB(mDB: mDB, method: "remove")
            return
        } catch StorageHelperError.closeDB(let message) {
            throw StorageHelperError.remove(message: message)
        } catch let error {
            let msg = error.localizedDescription
            throw StorageHelperError.remove(message: msg)
        }
    }

    // MARK: - Clear

    func clear() throws {
        var ret: Bool = false
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getWritableDatabase(filename: self.path,
                                                      secret: self.secret)
            let deleteStatementString = "DELETE FROM \(tableName);"

            var deleteStatement: OpaquePointer?
            if sqlite3_prepare_v2(mDB, deleteStatementString, -1, &deleteStatement,
                                  nil) == SQLITE_OK {
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    ret = true
                } else {
                    let msg = "Could not delete all rows."
                    throw StorageHelperError.clear(message: msg)
                }
            } else {
                let msg = "DELETE statement could not be prepared."
                throw StorageHelperError.clear(message: msg)
            }
            sqlite3_finalize(deleteStatement)
            if ret {
                try resetIndex()
            }
            try closeDB(mDB: mDB, method: "clear")
            return
        } catch StorageHelperError.resetIndex(let message) {
            throw StorageHelperError.clear(message: message)
        } catch StorageHelperError.closeDB(let message) {
            throw StorageHelperError.clear(message: message)
        } catch let error {
            let msg = error.localizedDescription
            throw StorageHelperError.clear(message: msg)
        }
    }

    // MARK: - SetTable

    func setTable(tblName: String) throws {
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getWritableDatabase(
                filename: self.path, secret: self.secret)
            try createTable(mDB: mDB, tableName: tblName,
                            ifNotExists: true)
            tableName = tblName
            // create index
            try createIndex(mDB: mDB, tableName: tableName,
                            colName: IDXCOLNAME,
                            ifNotExists: true)
            try closeDB(mDB: mDB, method: "setTable")
            return
        } catch StorageHelperError.creationIndex(let message) {
            throw StorageHelperError
            .setTable(message: message)
        } catch StorageHelperError.creationTable(let message) {
            throw StorageHelperError
            .setTable(message: message)
        } catch StorageHelperError.closeDB(let message) {
            throw StorageHelperError.setTable(message: message)
        } catch let error {
            throw StorageHelperError
            .setTable(message: error.localizedDescription)
        }
    }

    // MARK: - Keys

    func keys() throws -> [String] {
        var retArray: [String] = [String]()
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getReadableDatabase(filename: self.path,
                                                      secret: self.secret)
            let getKeysString: String = "SELECT * FROM \(tableName);"
            var getKeysStatement: OpaquePointer?
            if sqlite3_prepare_v2(mDB, getKeysString, -1, &getKeysStatement,
                                  nil) == SQLITE_OK {
                while sqlite3_step(getKeysStatement) == SQLITE_ROW {
                    let queryResultCol1 = sqlite3_column_text(getKeysStatement, 1)
                    if let mQueryResultCol1 = queryResultCol1 {
                        retArray.append(String(cString: mQueryResultCol1))
                    } else {
                        let msg = "Error in sqlite3_column_text"
                        throw StorageHelperError.keys(message: msg)
                    }
                }
            } else {
                let msg = "Error statement could not be prepared."
                throw StorageHelperError.keys(message: msg)
            }
            sqlite3_finalize(getKeysStatement)
            try closeDB(mDB: mDB, method: "keys")
            return retArray
        } catch StorageHelperError.keys(let message) {
            throw StorageHelperError.keys(message: message)
        } catch StorageHelperError.closeDB(let message) {
            throw StorageHelperError.keys(message: message)
        } catch let error {
            throw StorageHelperError
            .keys(message: error.localizedDescription)
        }
    }

    // MARK: - Values

    func values() throws -> [String] {
        var retArray: [String] = [String]()
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getReadableDatabase(filename: self.path, secret: self.secret)
            let getValuesString: String = "SELECT * FROM \(tableName);"
            var getValuesStatement: OpaquePointer?
            if sqlite3_prepare_v2(mDB, getValuesString, -1, &getValuesStatement, nil) == SQLITE_OK {
                while sqlite3_step(getValuesStatement) == SQLITE_ROW {
                    let queryResultCol2 = sqlite3_column_text(getValuesStatement, 2)
                    if let mQueryResultCol2 = queryResultCol2 {
                        retArray.append(String(cString: mQueryResultCol2))
                    } else {
                        let msg = "values: Error in sqlite3_column_text"
                        throw StorageHelperError.values(message: msg)
                    }
                }
            } else {
                let msg = "values: Error statement could not be prepared."
                throw StorageHelperError.values(message: msg)
            }
            sqlite3_finalize(getValuesStatement)
            try closeDB(mDB: mDB, method: "values")
            return retArray
        } catch StorageHelperError.values(let message) {
            throw StorageHelperError.values(message: message)
        } catch StorageHelperError.closeDB(let message) {
            throw StorageHelperError.values(message: message)
        } catch let error {
            throw StorageHelperError
            .values(message: error.localizedDescription)
        }
    }

    // MARK: - FilterValues

    func filtervalues(filter: String) throws -> [String] {
        var retArray: [String] = [String]()
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getReadableDatabase(filename: self.path,
                                                      secret: self.secret)
            var inFilter: String = filter
            if inFilter.prefix(1) != "%" && inFilter.suffix(1) != "%" {
                inFilter = "%" + inFilter + "%"
            }
            var getValuesString: String = "SELECT \(COLVALUE) FROM \(tableName) "
            getValuesString.append(" WHERE \(COLNAME) LIKE '\(inFilter)';")
            var getValuesStatement: OpaquePointer?
            if sqlite3_prepare_v2(mDB, getValuesString, -1, &getValuesStatement,
                                  nil) == SQLITE_OK {
                while sqlite3_step(getValuesStatement) == SQLITE_ROW {
                    let queryResultCol0 = sqlite3_column_text(getValuesStatement,
                                                              0)
                    if let mQueryResultCol0 = queryResultCol0 {
                        retArray.append(String(cString: mQueryResultCol0))
                    } else {
                        let msg = "Error in sqlite3_column_text"
                        throw StorageHelperError.filtervalues(message: msg)
                    }
                }
            } else {
                let msg = "Error statement could not be prepared."
                throw StorageHelperError.filtervalues(message: msg)
            }
            sqlite3_finalize(getValuesStatement)
            try closeDB(mDB: mDB, method: "filtervalues")
            return retArray
        } catch StorageHelperError.filtervalues(let message) {
            throw StorageHelperError.filtervalues(message: message)
        } catch StorageHelperError.closeDB(let message) {
            throw StorageHelperError.filtervalues(message: message)
        } catch let error {
            throw StorageHelperError
            .filtervalues(message: error.localizedDescription)
        }
    }

    // MARK: - KeysValues

    func keysvalues() throws -> [Data]? {
        var retArray: [Data] = [Data]()
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getReadableDatabase(filename: self.path, secret: self.secret)
            retArray = try getKeysValues(mDB: mDB)
            try closeDB(mDB: mDB, method: "keysvalues")
            return retArray
        } catch StorageHelperError.getKeysValues(let message) {
            throw StorageHelperError.keysvalues(message: message)
        } catch StorageHelperError.closeDB(let message) {
            throw StorageHelperError.keysvalues(message: message)
        } catch let error {
            throw StorageHelperError
            .keysvalues(message: error.localizedDescription)
        }
    }

    // MARK: - CloseDB

    func closeDB(mDB: OpaquePointer?, method: String) throws {
        var message: String = ""
        let returnCode: Int32 = sqlite3_close_v2(mDB)
        if returnCode != SQLITE_OK {
            let errmsg: String = String(cString: sqlite3_errmsg(mDB))
            message = "Error: \(method) closing the database rc: \(returnCode)" +
                " message: \(errmsg)"
            throw StorageHelperError.closeDB(message: message)
        }
    }

    // MARK: - CreateTable

    func createTable (mDB: OpaquePointer?, tableName: String,
                      ifNotExists: Bool) throws {
        let exist: String = ifNotExists ? "IF NOT EXISTS" : ""
        let createTableString: String = """
        CREATE TABLE \(exist) \(tableName) (
        \(COLID) INTEGER PRIMARY KEY AUTOINCREMENT,
        \(COLNAME) TEXT NOT NULL UNIQUE,
        \(COLVALUE) TEXT);
        """
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, createTableString, -1,
                              &createTableStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(createTableStatement) !=
                SQLITE_DONE {
                let msg = "Error \(tableName) table could not" +
                    " be created."
                throw StorageHelperError
                .creationTable(message: msg)
            }
        } else {
            let msg = "Error CREATE TABLE statement could not" +
                " be prepared."
            throw StorageHelperError
            .creationTable(message: msg)
        }
        sqlite3_finalize(createTableStatement)
        return
    }

    // MARK: - CreateIndex

    func createIndex(mDB: OpaquePointer?, tableName: String,
                     colName: String, ifNotExists: Bool)
    throws {
        let exist: String = ifNotExists ? "IF NOT EXISTS" : ""
        let idx: String = "index_\(tableName)_on_\(colName)"
        let createIndexString: String = "CREATE INDEX " +
            "\(exist) '\(idx)' ON '\(tableName)' " +
            "('\(colName)');"
        var createIndexStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, createIndexString, -1,
                              &createIndexStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(createIndexStatement) ==
                SQLITE_DONE {
            } else {
                let msg = "Error Index \(idx) on table " +
                    "\(tableName) could not be created."
                throw StorageHelperError
                .creationIndex(message: msg)
            }
        } else {
            let msg = "Error CREATE INDEX statement " +
                "could not be prepared."
            throw StorageHelperError
            .creationIndex(message: msg)
        }
        sqlite3_finalize(createIndexStatement)
        return
    }

    // MARK: - IsKeyExists

    private func isKeyExists(mDB: OpaquePointer?, key: String) throws -> Bool {
        var ret: Bool = false
        // check if the key already exists
        guard let data: Data = try getValue(mDB: mDB, key: key) else {
            let msg = "Error no data.name given"
            throw StorageHelperError.isKeyExists(message: msg)
        }
        if data.id != nil {
            ret = true
        }
        return ret
    }

    // MARK: - GetValue

    private func getValue(mDB: OpaquePointer?, key: String) throws -> Data? {
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
                    let msg = "Error in sqlite3_column_text column 1"
                    throw StorageHelperError.getValue(message: msg)
                }
                let queryResultCol2 = sqlite3_column_text(getStatement, 2)
                if let mQueryResultCol2 = queryResultCol2 {
                    rowData.value = String(cString: mQueryResultCol2)
                } else {
                    let msg = "Error in sqlite3_column_text column 2"
                    throw StorageHelperError.getValue(message: msg)
                }
                resArray.append(rowData)
            }
        } else {
            let msg = "Error statement could not be prepared."
            throw StorageHelperError.getValue(message: msg)
        }
        sqlite3_finalize(getStatement)
        if resArray.count > 0 {
            retData = resArray[0]
        } else {
            retData.id = nil
        }
        return retData
    }

    private func insertData(mDB: OpaquePointer?, data: Data) throws {

        let insertStatementString = "INSERT INTO " +
            "\(tableName) (\(COLNAME), \(COLVALUE)) " +
            "VALUES (?, ?);"
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, insertStatementString, -1, &insertStatement,
                              nil) == SQLITE_OK {
            guard let name: NSString = data.name as
                    NSString? else {
                let msg = "Could not find name."
                throw StorageHelperError.insertData(message: msg)
            }
            guard let value: NSString = data.value as
                    NSString? else {
                let msg = "Could not find value."
                throw StorageHelperError.insertData(message: msg)
            }
            sqlite3_bind_text(insertStatement, 1,
                              name.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2,
                              value.utf8String, -1, nil)
            if sqlite3_step(insertStatement) !=
                SQLITE_DONE {
                let msg = "Could not insert row."
                throw StorageHelperError.insertData(message: msg)
            }
        } else {
            let msg = "INSERT statement could " +
                "not be prepared."
            throw StorageHelperError.insertData(message: msg)
        }
        sqlite3_finalize(insertStatement)
        return
    }

    // MARK: - UpdateData

    private func updateData(mDB: OpaquePointer?, data: Data)
    throws {
        let updateStatementString = """
        UPDATE \(tableName) SET \(COLVALUE) = ?
        WHERE \(COLNAME) = ?;
        """
        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, updateStatementString,
                              -1, &updateStatement, nil) ==
            SQLITE_OK {
            guard let name: NSString = data.name as
                    NSString? else {
                let msg = "updateData: Could not find name."
                throw StorageHelperError.updateData(message: msg)
            }
            guard let value: NSString = data.value as
                    NSString? else {
                let msg = "updateData: Could not find value."
                throw StorageHelperError.updateData(message: msg)
            }
            sqlite3_bind_text(updateStatement, 1,
                              value.utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2,
                              name.utf8String, -1, nil)
            if sqlite3_step(updateStatement) != SQLITE_DONE {
                let msg = "updateData: Could not update row. "
                throw StorageHelperError.updateData(message: msg)
            }
        } else {
            let msg = "UPDATE statement could not be prepared"
            throw StorageHelperError.updateData(message: msg)
        }
        sqlite3_finalize(updateStatement)
        return

    }

    // MARK: - GetTables

    private func getTables(mDB: OpaquePointer?) throws -> [String] {
        var retArray: [String] = [String]()

        let getTablesString: String = """
        SELECT * FROM sqlite_master WHERE TYPE="table";
        """
        var getTablesStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, getTablesString, -1, &getTablesStatement,
                              nil) == SQLITE_OK {
            while sqlite3_step(getTablesStatement) == SQLITE_ROW {
                let queryResultCol1 = sqlite3_column_text(getTablesStatement, 1)
                if let mQueryResultCol1 = queryResultCol1 {
                    let name = String(cString: mQueryResultCol1)
                    if name != "sqlite_sequence" {
                        retArray.append(name)
                    }
                } else {
                    let msg = "Error in sqlite3_column_text column 1"
                    throw StorageHelperError.getTables(message: msg)
                }
            }
        } else {
            let msg = "Error statement could not be prepared."
            throw StorageHelperError.getTables(message: msg)
        }
        sqlite3_finalize(getTablesStatement)
        if retArray.count > 0 {
            return retArray
        } else {
            throw StorageHelperError.noTables
        }
    }

    // MARK: - ResetIndex

    private func resetIndex() throws {
        let mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.getWritableDatabase(filename: self.path,
                                                      secret: self.secret)
        } catch let error {
            throw StorageHelperError
            .resetIndex(message: error.localizedDescription)
        }
        let updateStatementString = "UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE " +
            " NAME='\(tableName)';"

        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, updateStatementString, -1, &updateStatement,
                              nil) == SQLITE_OK {

            if sqlite3_step(updateStatement) != SQLITE_DONE {
                let msg = "Error Could not reset Index."
                throw StorageHelperError.getTables(message: msg)
            }
        } else {
            let msg = "Error UPDATE statement could not be prepared."
            throw StorageHelperError.getTables(message: msg)
        }
        sqlite3_finalize(updateStatement)
        return
    }

    // MARK: - GetKeysValues

    private func getKeysValues(mDB: OpaquePointer?) throws -> [Data] {
        var retArray: [Data] = [Data]()
        let getKeysValuesString: String = "SELECT * FROM \(tableName);"
        var getKeysValuesStatement: OpaquePointer?
        if sqlite3_prepare_v2(mDB, getKeysValuesString, -1,
                              &getKeysValuesStatement, nil) == SQLITE_OK {
            while sqlite3_step(getKeysValuesStatement) == SQLITE_ROW {
                var rowData: Data = Data()
                let queryResultCol1 = sqlite3_column_text(getKeysValuesStatement,
                                                          1)
                if let mQueryResultCol1 = queryResultCol1 {
                    rowData.name = String(cString: mQueryResultCol1)
                } else {
                    let msg = "Error in sqlite3_column_text column 1."
                    throw StorageHelperError.getKeysValues(message: msg)
                }
                let queryResultCol2 = sqlite3_column_text(getKeysValuesStatement,
                                                          2)
                if let mQueryResultCol2 = queryResultCol2 {
                    rowData.value = String(cString: mQueryResultCol2)
                } else {
                    let msg = "Error in sqlite3_column_text column 2."
                    throw StorageHelperError.getKeysValues(message: msg)
                }
                retArray.append(rowData)
            }
            sqlite3_finalize(getKeysValuesStatement)
        } else {
            let msg = "Error statement could not be prepared."
            throw StorageHelperError.getKeysValues(message: msg)
        }
        return retArray

    }

    // MARK: - DeleteDB

    func deleteDB(databaseName: String) throws {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(databaseName)
            let isFileExists = FileManager.default.fileExists(atPath: fileURL.path)
            if isFileExists {
                do {
                    try FileManager.default.removeItem(at: fileURL)
                    print("Database \(databaseName) deleted")
                    isOpen = false
                    return
                } catch let error {
                    throw StorageHelperError
                    .deleteDB(message: error.localizedDescription)
                }
            } else {
                let msg = "File \(databaseName) does not exist"
                throw StorageHelperError.deleteDB(message: msg)
            }
        }
    }
}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
