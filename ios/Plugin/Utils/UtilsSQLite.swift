//
//  UtilsSQLite.swift
//  Plugin
//
//  Created by  Quéau Jean Pierre on 08/04/2021.
//  Copyright © 2021 Max Lynch. All rights reserved.
//

import Foundation

import SQLCipher

enum UtilsSQLiteError: Error {
    case connectionFailed
    case wrongSecret
    case wrongNewSecret
    case bindFailed
    case deleteFileFailed
    case encryptionFailed
    case filePathFailed
    case renameFileFailed
    case createStoreTableIndexes(message: String)
}

let SQLITETRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
// swiftlint:disable file_length
// swiftlint:disable type_body_length
class UtilsSQLite {

    // MARK: - CreateConnection

    class func createConnection(dbHelper: StorageDatabaseHelper, data: [String: String], encrypted: Bool,
                                secret: String, newsecret: String) -> String {
        var message: String = ""
        guard let path = data["path"] else {
            message = "init - createConnection: path not defined"
            return message
        }
        guard let tableName = data["tablename"] else {
            message = "init - createConnection: tableName not defined"
            return message
        }
         guard let IDXCOLNAME = data["idxcolname"] else {
             message = "init - createConnection: IDXCOLNAME not defined"
             return message
         }
        if !encrypted && data["mode"] == "no-encryption" {
            message = UtilsSQLite.createConnectionNoEncryption(dbHelper: dbHelper, path: path,
                        tableName: tableName, IDXCOLNAME: IDXCOLNAME)
        } else if encrypted && data["mode"] == "secret" && secret.count > 0 {
            message =
                UtilsSQLite.createConnectionEncryptedWithSecret(dbHelper: dbHelper, path: path, secret: secret,
                                                                newsecret: newsecret, tableName: tableName,
                                                                IDXCOLNAME: IDXCOLNAME)
        } else if encrypted && data["mode"] == "newsecret" && secret.count > 0 && newsecret.count > 0 {
            message =
                UtilsSQLite.createConnectionEncryptedWithNewSecret(dbHelper: dbHelper, path: path, secret: secret,
                                                                   newsecret: newsecret, tableName: tableName,
                                                                   IDXCOLNAME: IDXCOLNAME)
        } else if encrypted && data["mode"] == "encryption" && secret.count > 0 {
            message = UtilsSQLite.makeEncryption(dbHelper: dbHelper, path: path,
                                                 secret: secret, tableName: tableName, IDXCOLNAME: IDXCOLNAME)
        }
        return message
    }

    // MARK: - CreateConnectionNoEncryption

    class func createConnectionNoEncryption(dbHelper: StorageDatabaseHelper, path: String, tableName: String,
                                            IDXCOLNAME: String) -> String {
        var message: String = ""
        var mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.connection(filename: path)
            message = createStoreTableIndexes(dbHelper: dbHelper, mDB: mDB,
                                              tableName: tableName,
                                              IDXCOLNAME: IDXCOLNAME)
            try dbHelper.closeDB(mDB: mDB, method: "init")
            return message
        } catch StorageHelperError.closeDB(let message) {
            return message
        } catch {
            message = "init: Error Database connection failed"
            return message
        }
    }

    // MARK: - CreateConnectionEncryptedWithSecret

    // swiftlint:disable function_parameter_count
    class func createConnectionEncryptedWithSecret(dbHelper: StorageDatabaseHelper, path: String, secret: String,
                                                   newsecret: String, tableName: String, IDXCOLNAME: String) -> String {
        var message: String = ""
        var mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.connection(filename: path, readonly: false,
                                             key: secret)
            message = createStoreTableIndexes(dbHelper: dbHelper, mDB: mDB,
                                              tableName: tableName,
                                              IDXCOLNAME: IDXCOLNAME)
            try dbHelper.closeDB(mDB: mDB, method: "init")
            return message
        } catch StorageHelperError.closeDB(let message) {
            return message
        } catch {
            message = "init: Error Database connection failed wrong secret"
            return message
        }
    }

    // MARK: - CreateConnectionEncryptedWithNewSecret

    class func createConnectionEncryptedWithNewSecret(dbHelper: StorageDatabaseHelper,
                                                      path: String, secret: String, newsecret: String,
                                                      tableName: String, IDXCOLNAME: String) -> String {
        var message: String = ""
        var mDB: OpaquePointer?
        do {
            try mDB = UtilsSQLite.connection(filename: path, readonly: false, key: secret)

            let keyStatementString = """
            PRAGMA rekey = '\(newsecret)';
            """
            if sqlite3_exec(mDB, keyStatementString, nil, nil, nil) != SQLITE_OK {
                message = "connection: Unable to open a connection to database at \(path))"
                return message
            }
            /* this should work but does not sqlite3_rekey_v2 is not known
            if sqlite3_rekey_v2(db!, "\(path)", newsecret, Int32(newsecret.count)) == SQLITE_OK {
                self.isOpen = true
            } else {
                print("Unable to open a connection to database at \(path)")
                throw StorageDatabaseHelperError.wrongNewSecret
            }
            */
            message = createStoreTableIndexes(dbHelper: dbHelper, mDB: mDB, tableName: tableName,
                                              IDXCOLNAME: IDXCOLNAME)
            if message.count == 0 {
                message = "swap newsecret"
            }
            try dbHelper.closeDB(mDB: mDB, method: "init")
        } catch StorageHelperError.closeDB(let message) {
            return message
        } catch {
            message = "init: Error Database connection failed wrong secret"
        }
        return message
    }
    // swiftlint:enable function_parameter_count

    // MARK: - MakeEncryption

    class func makeEncryption(dbHelper: StorageDatabaseHelper, path: String, secret: String,
                              tableName: String, IDXCOLNAME: String) -> String {
        var retMessage: String = ""
        var res: Bool = false
        do {
            try res =
                UtilsSQLite.encryptDatabase(dbHelper: dbHelper, filePath: path, secret: secret,
                                            tableName: tableName, IDXCOLNAME: IDXCOLNAME)
            if res {
                    retMessage = "success encryption"
            }
        } catch UtilsSQLiteError.encryptionFailed {
            retMessage = "init: Error Database Encryption failed"
        } catch UtilsSQLiteError.filePathFailed {
            retMessage = "init: Error Database file not found"
        } catch UtilsSQLiteError.createStoreTableIndexes(let message) {
            retMessage = message
        } catch let error {
            retMessage = "init: Encryption \(error)"
        }
        return retMessage
    }

    // MARK: - Connection

    class func connection(filename: String, readonly: Bool = false, key: String = "") throws -> OpaquePointer? {
        let flags = readonly ? SQLITE_OPEN_READONLY : SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE
        var mDB: OpaquePointer?
        if sqlite3_open_v2(filename, &mDB, flags | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK {
            if key.count > 0 {
                let keyStatementString = """
                PRAGMA key = '\(key)';
                """
                if sqlite3_exec(mDB, keyStatementString, nil, nil, nil) == SQLITE_OK {
                    if sqlite3_exec(mDB, "SELECT count(*) FROM sqlite_master;", nil, nil, nil) != SQLITE_OK {
                        print("Unable to open a connection to database at \(filename)")
                        throw UtilsSQLiteError.wrongSecret
                    }
                } else {
                    print("connection: Unable to open a connection to database at \(filename)")
                    throw UtilsSQLiteError.wrongSecret
                }
            }
            /* this should work but doe not sqlite3_key_v2 is not known
            if key.count > 0 {
                let nKey:Int32 = Int32(key.count)
                if sqlite3_key_v2(db!, filename, key, nKey) == SQLITE_OK {
                    if (sqlite3_exec(db!, "SELECT count(*) FROM sqlite_master;", nil, nil, nil) != SQLITE_OK) {
                      print("Unable to open a connection to database at \(filename)")
                      throw StorageDatabaseHelperError.wrongSecret
                    }
                } else {
                    print("Unable to open a connection to database at \(filename)")
                    throw StorageDatabaseHelperError.wrongSecret
                }
            }
            print("Successfully opened connection to database at \(filename)")
            */
            return mDB
        } else {
            print("connection: Unable to open a connection to database at \(filename)")
            throw UtilsSQLiteError.connectionFailed
        }
    }

    // MARK: - GetWritableDatabase

    class func getWritableDatabase(filename: String, secret: String) throws -> OpaquePointer? {
        guard let mDB = try? connection(filename: filename, readonly: false, key: secret) else {
            throw UtilsSQLiteError.connectionFailed
        }
        return mDB
    }

    // MARK: - GetReadableDatabase

    class func getReadableDatabase(filename: String, secret: String) throws -> OpaquePointer? {
        guard let mDB = try? connection(filename: filename, readonly: true, key: secret) else {
            throw UtilsSQLiteError.connectionFailed
        }
        return mDB
    }

    // MARK: - Bind

    class func bind( handle: OpaquePointer, value: Any?, idx: Int) throws {

        if value == nil {
            sqlite3_bind_null(handle, Int32(idx))
        } else if let value = value as? Blob {
            sqlite3_bind_blob(handle, Int32(idx), value.bytes, Int32(value.bytes.count), SQLITETRANSIENT)
        } else if let value = value as? Double {
            sqlite3_bind_double(handle, Int32(idx), value)
        } else if let value = value as? Int64 {
            sqlite3_bind_int64(handle, Int32(idx), value)
        } else if let value = value as? String {
            sqlite3_bind_text(handle, Int32(idx), value, -1, SQLITETRANSIENT)
        } else if let value = value as? Int {
            sqlite3_bind_int(handle, Int32(idx), Int32(value))
         } else if let value = value as? Bool {
            var bInt: Int = 0
            if value {bInt = 1}
            sqlite3_bind_int(handle, Int32(idx), Int32(bInt))
        } else {
            throw UtilsSQLiteError.bindFailed
        }

    }

    // MARK: - GetColumnType

    class func getColumnType(index: Int32, stmt: OpaquePointer) -> Int32 {
        var type: Int32 = 0

        // Column types - http://www.sqlite.org/datatype3.html (section 2.2 table column 1)
        let blobTypes = ["BINARY", "BLOB", "VARBINARY"]
        var textTypes: [String] = ["CHAR", "CHARACTER", "CLOB", "NATIONAL VARYING CHARACTER", "NATIVE CHARACTER"]
        let textTypes1: [String] = ["NCHAR", "NVARCHAR", "TEXT", "VARCHAR", "VARIANT", "VARYING CHARACTER"]
        textTypes.append(contentsOf: textTypes1)
        let dateTypes = ["DATE", "DATETIME", "TIME", "TIMESTAMP"]
        var intTypes  = ["BIGINT", "BIT", "BOOL", "BOOLEAN", "INT", "INT2", "INT8", "INTEGER", "MEDIUMINT"]
        let intTypes1: [String] = ["SMALLINT", "TINYINT"]
        intTypes.append(contentsOf: intTypes1)
        let nullTypes = ["NULL"]
        let realTypes = ["DECIMAL", "DOUBLE", "DOUBLE PRECISION", "FLOAT", "NUMERIC", "REAL"]

        // Determine type of column - http://www.sqlite.org/c3ref/c_blob.html
        let declaredType = sqlite3_column_decltype(stmt, index)

           if let dclType = declaredType {
            var declaredType = String(cString: dclType).uppercased()

            if let index = declaredType.firstIndex(of: "(" ) {
                declaredType = String(declaredType[..<index])
            }

            if intTypes.contains(declaredType) {
                return SQLITE_INTEGER
            }
            if realTypes.contains(declaredType) {
                return SQLITE_FLOAT
            }
            if textTypes.contains(declaredType) {
                return SQLITE_TEXT
            }
            if blobTypes.contains(declaredType) {
                return SQLITE_BLOB
            }
            if dateTypes.contains(declaredType) {
                return SQLITE_FLOAT
            }
            if nullTypes.contains(declaredType) {
                return SQLITE_NULL
            }
            return SQLITE_NULL
        } else {
            type = sqlite3_column_type(stmt, index)
            return type
        }
    }

    // MARK: - GetColumnValue

    class func getColumnValue(index: Int32, type: Int32, stmt: OpaquePointer) -> Any? {
        switch type {
        case SQLITE_INTEGER:
            let val = sqlite3_column_int(stmt, index)
            return Int(val)
        case SQLITE_FLOAT:
            let val = sqlite3_column_double(stmt, index)
            return Double(val)
        case SQLITE_BLOB:
            let data = sqlite3_column_blob(stmt, index)
            let size = sqlite3_column_bytes(stmt, index)
            let val = NSData(bytes: data, length: Int(size))
            return val
        case SQLITE_TEXT:
            let buffer = sqlite3_column_text(stmt, index)
            var val: String
            if let mBuffer = buffer {
                val = String(cString: mBuffer)
            } else {
                val = "NULL"
            }
            return val
        default:
            return nil
        }
    }

    // MARK: - IsFileExist

    class func isFileExist(filePath: String) -> Bool {
        var ret: Bool = false
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            ret = true
         }
        return ret
    }

    // MARK: - GetFilePath

    class func getFilePath(fileName: String) throws -> String {
        if let path: String = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first {
            let url = NSURL(fileURLWithPath: path)
            if let pathComponent = url.appendingPathComponent("\(fileName)") {
                return pathComponent.path
            } else {
                throw UtilsSQLiteError.filePathFailed
            }
        } else {
            throw UtilsSQLiteError.filePathFailed
        }
    }

    // MARK: - DeleteFile

    class func deleteFile(fileName: String) throws -> Bool {
        var ret: Bool = false

        do {
            let filePath: String = try getFilePath(fileName: fileName)
            if isFileExist(filePath: filePath) {
                let fileManager = FileManager.default
                do {
                    try fileManager.removeItem(atPath: filePath)
                    ret = true
                } catch let error {
                    print("Error: \(error)")
                    throw UtilsSQLiteError.deleteFileFailed
                }
            }
        } catch let error {
            print("Error: \(error)")
            throw UtilsSQLiteError.filePathFailed
        }
        return ret
    }

    // MARK: - RenameFile

    class func renameFile (filePath: String, toFilePath: String) throws {
         let fileManager = FileManager.default
         do {
            if isFileExist(filePath: toFilePath) {
                let fileName = URL(fileURLWithPath: toFilePath).lastPathComponent
                try  _ = deleteFile(fileName: fileName)
            }

             try fileManager.moveItem(atPath: filePath, toPath: toFilePath)
         } catch let error {
            print("Error: \(error)")
             throw UtilsSQLiteError.renameFileFailed
         }
    }

    // MARK: - EncryptDatabase

    class func encryptDatabase(dbHelper: StorageDatabaseHelper, filePath: String, secret: String,
                               tableName: String, IDXCOLNAME: String) throws -> Bool {
        var ret: Bool = false
        var mDB: OpaquePointer?
        do {
            if isFileExist(filePath: filePath) {
                do {
                    let tempPath: String = try getFilePath(fileName: "temp.db")
                    try renameFile(filePath: filePath, toFilePath: tempPath)
                    try mDB = UtilsSQLite.connection(filename: tempPath)
                    try _ = UtilsSQLite.connection(filename: filePath, readonly: false, key: secret)
                    let stmt: String = """
                    ATTACH DATABASE '\(filePath)' AS encrypted KEY '\(secret)';
                    SELECT sqlcipher_export('encrypted');
                    DETACH DATABASE encrypted;
                    """
                    if sqlite3_exec(mDB, stmt, nil, nil, nil) == SQLITE_OK {
                        try _ = deleteFile(fileName: "temp.db")
                        let message: String =
                            createStoreTableIndexes(dbHelper: dbHelper, mDB: mDB, tableName: tableName,
                                                    IDXCOLNAME: IDXCOLNAME)
                        if message.count > 0 {
                            throw UtilsSQLiteError.createStoreTableIndexes(message: message)
                        }
                        ret = true
                    }
                } catch let error {
                    print("Error: \(error)")
                    throw UtilsSQLiteError.encryptionFailed
                }
            }
            try dbHelper.closeDB(mDB: mDB, method: "init")
            return ret
        } catch StorageHelperError.closeDB(let message) {
            print("Error: \(message)")
            throw UtilsSQLiteError.encryptionFailed
        } catch let error {
            print("Error: \(error)")
            throw UtilsSQLiteError.filePathFailed
        }
    }

    // MARK: - CreateStoreTableIndexes

    class func createStoreTableIndexes(dbHelper: StorageDatabaseHelper, mDB: OpaquePointer?,
                                       tableName: String, IDXCOLNAME: String) -> String {
        let message = ""
        do {
            // create table
            try dbHelper.createTable(mDB: mDB, tableName: tableName,
                                     ifNotExists: true)
            // create index
            try dbHelper.createIndex(mDB: mDB, tableName: tableName,
                                     colName: IDXCOLNAME, ifNotExists: true)
        } catch StorageHelperError.creationIndex(let message) {
            return message
        } catch StorageHelperError.creationTable(let message) {
            return message
        } catch let error {
            return error.localizedDescription
        }
        return message
    }
}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
