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
    case open(message: String)
    case close(message: String)
    case setTable(message: String)
    case setkey(message: String)
    case getkey(message: String)
    case iskey(message: String)
    case remove(message: String)
    case clear(message: String)
    case isKeyExists(message: String)
    case closeDB(message: String)
    case getValue(message: String)
    case resetIndex(message: String)
    case keys(message: String)
    case values(message: String)
    case filtervalues(message: String)
    case keysvalues(message: String)
    case getKeysValues(message: String)
    case encryptionFailed
    case deleteFileFailed
    case fileNotExist
    case alreadyEncrypted
    case renameFileFailed
    case insertRowFailed
    case deleteStore
    case deleteDB(message: String)
    case isTable(message: String)
    case tables(message: String)
    case deleteTable(message: String)
    case importFromJson(message: String)
    case exportToJson(message: String)
}
// swiftlint:disable type_body_length
// swiftlint:disable file_length
class StorageDatabaseHelper {
    var isOpen: Bool = false
    var mDB: OpaquePointer?
    var tableName: String
    var encrypted: Bool
    var dbName: String
    var mode: String
    // define the path for the database
    var path: String = ""
    var globalData: Global = Global()

    // MARK: - Init

    init(databaseName: String, tableName: String, encrypted: Bool,
         mode: String) throws {
        self.tableName = tableName
        self.mode = mode
        self.encrypted = encrypted
        self.dbName = databaseName
        do {
            self.path = try UtilsFile.getFilePath(
                fileName: databaseName)
        } catch UtilsFileError.getFilePathFailed {
            throw StorageHelperError
            .initFailed(message: "Could not generate the store path")
        }
        print("database path \(self.path)")
        if self.path.count > 0 {
            do {
                try open()
            } catch StorageHelperError.open(let message) {
                throw StorageHelperError.initFailed(message: message)
            }
        } else {
            let msg = "Could not generate the store path"
            throw StorageHelperError.initFailed(message: msg)
        }
    }

    // MARK: - Open

    // swiftlint:disable function_body_length
    func open () throws {
        var password: String = ""
        if encrypted && (mode == "secret" || mode == "newsecret"
                            || mode == "encryption") {
            password = globalData.secret
        }
        if mode == "newsecret" {
            do {
                try UtilsSQLCipher
                    .changePassword(filename: path,
                                    password: password,
                                    newpassword: globalData.newsecret)
                password = globalData.newsecret

            } catch UtilsSQLCipherError.changePassword(let message) {
                let msg: String = "Failed in changePassword \(message)"
                throw StorageHelperError.open(message: msg)

            }
        }
        if mode == "encryption" {
            do {
                let ret: Bool = try UtilsEncryption
                    .encryptDatabase(filePath: path, password: password)
                if !ret {
                    let msg: String = "Failed in encryption"
                    throw StorageHelperError.open(message: msg)
                }
            } catch UtilsEncryptionError.encryptionFailed(let message) {
                let msg: String = "Failed in encryption \(message)"
                throw StorageHelperError.open(message: msg)

            }
        }

        do {
            mDB = try UtilsSQLCipher
                .openOrCreateDatabase(filename: path,
                                      password: password,
                                      readonly: false)
            if mDB != nil {
                isOpen = true
                try setTable(tblName: self.tableName)
                return
            } else {
                isOpen = false
                throw StorageHelperError.open(message: "No store returned" )
            }
        } catch StorageHelperError.setTable(let message) {
            isOpen = false
            throw StorageHelperError.open(message: message )
        } catch UtilsSQLCipherError.openOrCreateDatabase(let message) {
            isOpen = false
            var msg: String = "Failed in "
            msg.append("openOrCreateDatabase \(message)")
            throw StorageHelperError.open(message: msg )
        }
    }
    // swiftlint:enable function_body_length
    // MARK: - Close

    func close() throws {
        if mDB != nil {
            if isOpen {
                do {
                    try UtilsSQLCipher.closeDB(mDB: self)
                    return
                } catch UtilsSQLCipherError.closeDB(let message) {
                    throw StorageHelperError.close(message: message)
                }
            } else {
                return
            }
        } else {
            throw StorageHelperError.close(message: "No store returned" )
        }
    }

    // MARK: - SetTable

    func setTable(tblName: String) throws {
        if mDB != nil {
            do {
                try UtilsSQLCipher.createTable(mDB: self,
                                               tableName: tblName,
                                               ifNotExists: true)
                tableName = tblName
                // create index
                try UtilsSQLCipher.createIndex(mDB: self,
                                               tableName: tblName,
                                               ifNotExists: true)
                return
            } catch UtilsSQLCipherError.creationIndex(let message) {
                throw StorageHelperError.setTable(message: message)
            } catch UtilsSQLCipherError.creationTable(let message) {
                throw StorageHelperError.setTable(message: message)
            } catch let error {
                throw StorageHelperError
                .setTable(message: error.localizedDescription)
            }

        } else {
            throw StorageHelperError.setTable(message: "No store returned" )
        }
    }

    // MARK: - Get

    func get(name: String) throws -> Data? {
        if mDB != nil && isOpen {
            var result: [[String: Any]] = []
            var retData: Data = Data()
            do {
                let getString: String = """
                SELECT * FROM \(tableName) WHERE \(COLNAME) = '\(name)';
                """
                result = try UtilsSQLCipher.querySQL(mDB: self,
                                                     sql: getString,
                                                     values: [])
                if result.count == 1 {
                    guard let name = result[0]["name"] as? String else {
                        let msg = "no returned key"
                        throw StorageHelperError.getkey(message: msg)
                    }
                    guard let value = result[0]["value"] as? String else {
                        let msg = "no returned value"
                        throw StorageHelperError.getkey(message: msg)
                    }
                    guard let mID = result[0]["id"] as? Int64 else {
                        let msg = "no returned id"
                        throw StorageHelperError.getkey(message: msg)
                    }
                    retData.id = mID
                    retData.name = name
                    retData.value = value
                } else {
                    retData.id = nil
                }
                return retData
            } catch UtilsSQLCipherError.querySQL(let message) {
                throw StorageHelperError.getkey(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw StorageHelperError.getkey(message: msg)
            }
        } else {
            throw StorageHelperError.getkey(message: "No store not opened" )
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

    // MARK: - Set

    func set(data: Data) throws {
        if mDB != nil && isOpen {
            // check if the data already exists
            guard let key: String = data.name else {
                let msg = "no data.name given"
                throw StorageHelperError.setkey(message: msg)
            }
            do {
                let isKeyExists = try iskey(name: key)
                if isKeyExists {
                    try UtilsSQLCipher.updateData(mDB: self,
                                                  tableName: tableName,
                                                  data: data)
                } else {
                    try UtilsSQLCipher.insertData(mDB: self,
                                                  tableName: tableName,
                                                  data: data)
                }
            } catch StorageHelperError.iskey(let message) {
                throw StorageHelperError.setkey(message: message)
            } catch UtilsSQLCipherError.insertData(let message) {
                throw StorageHelperError.setkey(message: message)
            } catch UtilsSQLCipherError.updateData(let message) {
                throw StorageHelperError.setkey(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw StorageHelperError.setkey(message: msg)
            }
        } else {
            throw StorageHelperError.setkey(message: "No store not opened" )
        }
    }

    // MARK: - Remove

    func remove(name: String) throws {
        do {
            let deleteStatement = "DELETE FROM \(tableName) WHERE " +
                "\(COLNAME) = '\(name)';"
            try UtilsSQLCipher.execute(mDB: self, sql: deleteStatement)
            return
        } catch UtilsSQLCipherError.execute(let message) {
            throw StorageHelperError.remove(message: message)
        } catch let error {
            let msg = error.localizedDescription
            throw StorageHelperError.remove(message: msg)
        }
    }

    // MARK: - Clear

    func clear() throws {
        if mDB != nil && isOpen {
            do {
                let deleteStatementString = "DELETE FROM \(tableName);"
                try UtilsSQLCipher.execute(mDB: self,
                                           sql: deleteStatementString)
                let resetStatement = "UPDATE SQLITE_SEQUENCE SET SEQ=0 " +
                    "WHERE NAME='" + tableName + "';"
                try UtilsSQLCipher.execute(mDB: self,
                                           sql: resetStatement)
                return
            } catch UtilsSQLCipherError.execute(let message) {
                throw StorageHelperError.clear(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw StorageHelperError.remove(message: msg)
            }
        } else {
            throw StorageHelperError.getkey(message: "No store not opened" )
        }
    }

    // MARK: - DeleteDB

    func deleteDB(databaseName: String) throws {
        do {
            try UtilsSQLCipher.deleteDB(databaseName: databaseName)
            return
        } catch UtilsSQLCipherError.deleteDB(let message) {
            throw StorageHelperError.deleteDB(message: message)
        }
    }

    // MARK: - Keys

    func keys() throws -> [String] {
        var retArray: [String] = [String]()
        if mDB != nil && isOpen {
            let keysStatement = "SELECT \(COLNAME) FROM \(tableName) ORDER BY \(COLNAME);"
            var results: [[String: Any]] = []
            do {
                results = try UtilsSQLCipher.querySQL(mDB: self,
                                                      sql: keysStatement,
                                                      values: [])
                if results.count > 0 {
                    for res in results {
                        guard let name = res["name"] as? String else {
                            let msg = "no returned key"
                            throw StorageHelperError.keys(message: msg)
                        }
                        retArray.append(name)
                    }
                }
                return retArray
            } catch UtilsSQLCipherError.querySQL(let message) {
                throw StorageHelperError.keys(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw StorageHelperError.keys(message: msg)
            }
        } else {
            throw StorageHelperError.keys(message: "No store not opened" )
        }
    }

    // MARK: - Values

    func values() throws -> [String] {
        var retArray: [String] = [String]()
        if mDB != nil && isOpen {
            let valuesStatement = "SELECT \(COLVALUE) FROM \(tableName) ORDER BY \(COLNAME);"
            var results: [[String: Any]] = []
            do {
                results = try UtilsSQLCipher.querySQL(mDB: self,
                                                      sql: valuesStatement,
                                                      values: [])
                if results.count > 0 {
                    for res in results {
                        guard let value = res["value"] as? String else {
                            let msg = "no returned value"
                            throw StorageHelperError.values(message: msg)
                        }
                        retArray.append(value)
                    }
                }
                return retArray
            } catch UtilsSQLCipherError.querySQL(let message) {
                throw StorageHelperError.values(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw StorageHelperError.values(message: msg)
            }
        } else {
            throw StorageHelperError.values(message: "No store not opened" )
        }
    }

    // MARK: - FilterValues

    func filtervalues(filter: String) throws -> [String] {
        var retArray: [String] = [String]()
        if mDB != nil && isOpen {
            var inFilter: String = filter
            if inFilter.prefix(1) != "%" && inFilter.suffix(1) != "%" {
                inFilter = "%" + inFilter + "%"
            }
            var valuesStatement = "SELECT \(COLVALUE) FROM \(tableName)"
            valuesStatement.append(" WHERE \(COLNAME) LIKE '\(inFilter)';")
            var results: [[String: Any]] = []
            do {
                results = try UtilsSQLCipher.querySQL(mDB: self,
                                                      sql: valuesStatement,
                                                      values: [])
                if results.count > 0 {
                    for res in results {
                        guard let value = res["value"] as? String else {
                            let msg = "no returned value"
                            throw StorageHelperError
                            .filtervalues(message: msg)
                        }
                        retArray.append(value)
                    }
                }
                return retArray
            } catch UtilsSQLCipherError.querySQL(let message) {
                throw StorageHelperError.filtervalues(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw StorageHelperError.filtervalues(message: msg)
            }
        } else {
            throw StorageHelperError
            .filtervalues(message: "No store not opened" )
        }
    }

    // MARK: - KeysValues

    func keysvalues() throws -> [Data] {
        var retArray: [Data] = [Data]()
        if mDB != nil && isOpen {
            let keysStatement = "SELECT * FROM \(tableName) ORDER BY \(COLNAME);"
            var results: [[String: Any]] = []
            do {
                results = try UtilsSQLCipher.querySQL(mDB: self,
                                                      sql: keysStatement,
                                                      values: [])
                if results.count > 0 {
                    for res in results {
                        guard let name = res["name"] as? String else {
                            let msg = "no returned key"
                            throw StorageHelperError
                            .keysvalues(message: msg)
                        }
                        guard let value = res["value"] as? String else {
                            let msg = "no returned value"
                            throw StorageHelperError
                            .keysvalues(message: msg)
                        }
                        guard let mID = res["id"] as? Int64 else {
                            let msg = "no returned id"
                            throw StorageHelperError
                            .keysvalues(message: msg)
                        }
                        var data: Data = Data()
                        data.id = mID
                        data.name = name
                        data.value = value
                        retArray.append(data)
                    }
                }
                return retArray
            } catch UtilsSQLCipherError.querySQL(let message) {
                throw StorageHelperError.keysvalues(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw StorageHelperError.keysvalues(message: msg)
            }
        } else {
            let msg = "No store not opened"
            throw StorageHelperError.keysvalues(message: msg)
        }
    }

    // MARK: - IsTable

    func isTable(name: String) throws -> Bool {
        var ret: Bool = false
        var retArray: [String] = [String]()
        do {
            retArray = try UtilsSQLCipher.getTables(mDB: self)
            if retArray.contains(name) {ret = true}
            return ret
        } catch UtilsSQLCipherError.getTables(let message) {
            throw StorageHelperError.isTable(message: message)
        } catch let error {
            throw StorageHelperError
            .isTable(message: error.localizedDescription)
        }
    }

    // MARK: - tables

    func tables() throws -> [String] {
        var retArray: [String] = [String]()
        do {
            retArray = try UtilsSQLCipher.getTables(mDB: self)
            return retArray
        } catch UtilsSQLCipherError.getTables(let message) {
            throw StorageHelperError.tables(message: message)
        } catch let error {
            throw StorageHelperError
            .tables(message: error.localizedDescription)
        }
    }

    // MARK: - DeleteTable

    func deleteTable(tableName: String) throws {
        var retArray: [String] = [String]()

        do {
            retArray = try UtilsSQLCipher.getTables(mDB: self)
            if retArray.contains(tableName) {
                try UtilsSQLCipher.dropTable(mDB: self,
                                             tableName: tableName)
            }
            return
        } catch UtilsSQLCipherError.dropTable(let message) {
            throw StorageHelperError.deleteTable(message: message)
        } catch UtilsSQLCipherError.getTables(let message) {
            throw StorageHelperError.deleteTable(message: message)
        } catch let error {
            throw StorageHelperError
            .deleteTable(message: error.localizedDescription)
        }

    }

    // MARK: - ImportFromJson

    func importFromJson(values: [JsonValue]) throws -> Int {
        var changes: Int = 0
        do {
            for val in values {
                var data: Data = Data()
                data.name = val.key
                data.value = val.value
                try set(data: data)
                changes += 1
            }
            return changes
        } catch StorageHelperError.setkey(let message) {
            throw StorageHelperError.importFromJson(message: message)
        }
    }

    // MARK: - ExportToJson

    func exportToJson() throws -> [String: Any] {
        var retObj: [String: Any] = [:]
        do {
            let previousTableName: String = tableName
            retObj["database"] = String(dbName.dropLast(9))
            retObj["encrypted"] = encrypted
            var rTables: [Any] = []
            retObj["tables"] = []
            let tables: [String] = try tables()
            for table in tables {
                var rtable: [String: Any] = [:]
                tableName = table
                rtable["name"] = table
                let dataTable: [Data] = try keysvalues()
                var values: [Any] = []
                for data in dataTable {
                    var rData: [String: String] = [:]
                    rData["key"] = data.name
                    rData["value"] = data.value
                    values.append(rData)
                }
                rtable["values"] = values
                rTables.append(rtable)
            }
            retObj["tables"] = rTables
            tableName = previousTableName
            return retObj
        } catch StorageHelperError.tables(let message) {
            throw StorageHelperError.exportToJson(message: message)
        } catch StorageHelperError.keysvalues(let message) {
            throw StorageHelperError.exportToJson(message: message)
        }
    }

}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
