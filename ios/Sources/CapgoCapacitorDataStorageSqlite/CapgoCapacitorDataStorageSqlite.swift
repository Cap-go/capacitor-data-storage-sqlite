import Foundation

enum CapgoCapacitorDataStorageSqliteError: Error {
    case failed(message: String)
}

// swiftlint:disable file_length
// swiftlint:disable type_body_length
@objc public class CapgoCapacitorDataStorageSqlite: NSObject {
    var mDb: StorageDatabaseHelper?

    // MARK: - Echo

    @objc public func echo(_ value: String) -> String {
        return value
    }

    // MARK: - OpenStore

    @objc func openStore(_ dbName: String, tableName: String,
                         encrypted: Bool, inMode: String
    ) throws {
        do {
            mDb = try StorageDatabaseHelper(
                databaseName: "\(dbName)SQLite.db",
                tableName: tableName,
                encrypted: encrypted, mode: inMode)
        } catch StorageHelperError.initFailed(let message) {
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        } catch let error {
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: error.localizedDescription)
        }
        if !(mDb?.isOpen ?? true) {
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: "store not opened")
        } else {
            return
        }
    }

    // MARK: - closeStore

    @objc func closeStore(_ name: String) throws {
        if mDb != nil && ((mDb?.isOpen) != nil) &&
            mDb?.dbName == "\(name)SQLite.db" {
            do {
                try mDb?.close()
                return
            } catch StorageHelperError.close(let message) {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: msg)
            }
        } else {
            let message = "No database connection"
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        }

    }

    // MARK: - isStoreExists

    @objc func isStoreExists(_ name: String) throws -> NSNumber {

        let result: Bool = UtilsFile
            .isFileExist(fileName: "\(name)SQLite.db")
        if result {
            return 1
        } else {
            return 0
        }
    }

    // MARK: - isStoreOpen

    @objc func isStoreOpen(_ name: String) throws -> NSNumber {
        if mDb != nil {
            if mDb?.dbName == "\(name)SQLite.db" && ((mDb?.isOpen) != nil) {
                return 1
            } else {
                return 0
            }
        } else {
            let message = "No database connection"
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        }
    }

    // MARK: - setTable

    @objc func setTable(_ tableName: String) throws {

        if mDb != nil {
            do {
                try mDb?.setTable(tblName: tableName)
                return
            } catch StorageHelperError.setTable(let message) {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: message)
            } catch let error {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: error.localizedDescription)
            }
        } else {
            let message = "Must open a store first"
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        }
    }

    // MARK: - set

    @objc func set(_ data: Any) throws {
        if mDb != nil {
            if let mData = data as? Data {
                do {
                    try mDb?.set(data: mData)
                } catch StorageHelperError.setkey(let message) {
                    throw CapgoCapacitorDataStorageSqliteError
                    .failed(message: message)
                } catch let error {
                    let msg = error.localizedDescription
                    throw CapgoCapacitorDataStorageSqliteError
                    .failed(message: msg)
                }
            } else {
                let message = "data is not of type Data"
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: message)
            }
        } else {
            let message = "No database connection"
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        }
    }

    // MARK: - get

    @objc func get(_ name: String) throws -> String {

        if mDb != nil {
            do {
                if let data: Data = try mDb?.get(name: name) {
                    if let value = data.value {
                        return value
                    } else {
                        return ""
                    }
                } else {
                    let message = "No Data returned"
                    throw CapgoCapacitorDataStorageSqliteError
                    .failed(message: message)
                }
            } catch CapgoCapacitorDataStorageSqliteError.failed(let message) {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: message)
            } catch StorageHelperError.getkey(let message) {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: msg)
            }
        } else {
            let message = "No database connection"
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        }
    }

    // MARK: - remove

    @objc func remove(_ name: String) throws {
        if mDb != nil {
            do {
                try mDb?.remove(name: name)
                return
            } catch StorageHelperError.remove(let message) {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: msg)
            }
        } else {
            let message = "No database connection"
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        }

    }

    // MARK: - clear

    @objc func clear() throws {
        if mDb != nil {
            do {
                try mDb?.clear()
                return
            } catch StorageHelperError.clear(let message) {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: msg)
            }
        } else {
            let message = "No database connection"
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        }

    }

    // MARK: - iskey

    @objc func iskey(_ name: String) throws -> NSNumber {
        if mDb != nil {
            do {
                let result: Bool = try mDb?.iskey(name: name) ?? false
                if result {
                    return 1
                } else {
                    return 0
                }
            } catch StorageHelperError.iskey(let message) {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: msg)
            }
        } else {
            let message = "No database connection"
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        }
    }

    // MARK: - keys

    @objc func keys() throws -> [String] {
        if mDb != nil {
            do {
                let result = try mDb?.keys() ?? []
                return result
            } catch StorageHelperError.keys(let message) {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: msg)
            }
        } else {
            let message = "No database connection"
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        }
    }

    // MARK: - values

    @objc func values() throws -> [String] {
        if mDb != nil {
            do {
                let result = try mDb?.values() ?? []
                return result
            } catch StorageHelperError.values(let message) {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: msg)
            }
        } else {
            let message = "No database connection"
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        }
    }

    // MARK: - filtervalues

    @objc func filtervalues(filter: String) throws -> [String] {
        if mDb != nil {
            do {
                let result = try mDb?.filtervalues(filter: filter) ?? []
                return result

            } catch StorageHelperError.filtervalues(let message) {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: msg)
            }
        } else {
            let message = "No database connection"
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        }
    }

    // MARK: - keysvalues

    @objc func keysvalues() throws -> [[String: String]] {
        if mDb != nil {
            var dicArray: [[String: String]] = []
            do {
                let results = try mDb?.keysvalues() ?? []
                for result in results {
                    let res = ["key": result.name ?? "",
                               "value": result.value ?? ""]
                    dicArray.append(res)
                }
                return dicArray

            } catch StorageHelperError.keysvalues(let message) {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: msg)
            }
        } else {
            let message = "No database connection"
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        }
    }

    // MARK: - deleteStore

    @objc func deleteStore(storeName: String) throws {
        do {
            try UtilsFile.deleteFile(fileName: "\(storeName)SQLite.db")
            return
        } catch UtilsFileError.deleteFileFailed {
            let message = "Failed in delete file"
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        } catch let error {
            let msg = error.localizedDescription
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: msg)
        }
    }

    // MARK: - isTable

    @objc func isTable(_ name: String) throws -> NSNumber {
        if mDb != nil {
            do {
                let result: Bool = try mDb?.isTable(name: name) ?? false
                if result {
                    return 1
                } else {
                    return 0
                }
            } catch StorageHelperError.isTable(let message) {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: msg)
            }
        } else {
            let message = "No database connection"
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        }
    }

    // MARK: - tables

    @objc func tables() throws -> [String] {
        if mDb != nil {
            do {
                let result = try mDb?.tables() ?? []
                return result
            } catch StorageHelperError.tables(let message) {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: msg)
            }
        } else {
            let message = "No database connection"
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        }
    }

    // MARK: - deleteTable

    @objc func deleteTable(_ tableName: String) throws {

        if mDb != nil {
            do {
                try mDb?.deleteTable(tableName: tableName)
                return
            } catch StorageHelperError.deleteTable(let message) {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: message)
            } catch let error {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: error.localizedDescription)
            }
        } else {
            let message = "Must open a store first"
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        }
    }

    // MARK: - isJsonValid

    @objc func isJsonValid(_ parsingData: String) throws {

        if let data = ("["+parsingData+"]").data(using: .utf8) {
            do {
                _ = try JSONDecoder().decode([JsonStore].self,
                                             from: data)
                return
            } catch let error {
                let msg: String = "\(error.localizedDescription)"
                throw CapgoCapacitorDataStorageSqliteError.failed(message: msg)
            }
        } else {
            let msg: String = "Stringify Json Object not Valid"
            throw CapgoCapacitorDataStorageSqliteError.failed(message: msg)
        }
    }

    // MARK: - importFromJson

    // swiftlint:disable function_body_length
    @objc func importFromJson(_ parsingData: String)
    throws -> [String: Int] {
        var mDb: StorageDatabaseHelper
        if let data = ("["+parsingData+"]").data(using: .utf8) {
            // check jsonStore validity
            var jsonStore: [JsonStore]
            do {
                jsonStore = try JSONDecoder()
                    .decode([JsonStore].self, from: data)
            } catch let error {
                var msg: String = "Stringify Json Object not Valid "
                msg.append("\(error.localizedDescription)")
                throw CapgoCapacitorDataStorageSqliteError.failed(message: msg)
            }
            var totalChanges = 0
            let encrypted: Bool = jsonStore[0].encrypted
            let dbName: String =  jsonStore[0].database
            let mode: String  = encrypted ? "secret" : ""
            do {
                for table in jsonStore[0].tables {
                    // open the database
                    mDb = try StorageDatabaseHelper(
                        databaseName: "\(dbName)SQLite.db",
                        tableName: table.name,
                        encrypted: encrypted, mode: mode)
                    if !(mDb.isOpen ) {
                        throw CapgoCapacitorDataStorageSqliteError
                        .failed(message: "store not opened")
                    }

                    // import table from json table values
                    let changes: Int = try mDb
                        .importFromJson(values: table.values)
                    if changes < 1 {
                        let msg: String = "changes < 1"
                        throw CapgoCapacitorDataStorageSqliteError
                        .failed(message: msg)
                    }
                    try mDb.close()
                    totalChanges += changes
                }
                return ["changes": totalChanges]
            } catch StorageHelperError.initFailed(let message) {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: message)
            } catch StorageHelperError.close(let message) {
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: message)
            } catch StorageHelperError.importFromJson(let message) {
                let msg = message
                do {
                    try closeStore(dbName)
                    throw CapgoCapacitorDataStorageSqliteError.failed(message: msg)
                } catch let error {
                    throw CapgoCapacitorDataStorageSqliteError
                    .failed(message: error.localizedDescription)
                }
            } catch let error {
                print("\(error)")
                throw CapgoCapacitorDataStorageSqliteError
                .failed(message: error.localizedDescription)
            }

        } else {
            let msg: String = "Stringify Json Object not Valid"
            throw CapgoCapacitorDataStorageSqliteError.failed(message: msg)
        }
    }
    // swiftlint:enable function_body_length

    // MARK: - exportToJson

    @objc func exportToJson()
    throws -> [String: Any] {
        if mDb != nil {
            do {
                let res: [String: Any] = try
                    mDb?.exportToJson() ?? [:]
                return res
            } catch StorageHelperError.exportToJson(let message) {
                throw CapgoCapacitorDataStorageSqliteError.failed(message: message)
            } catch let error {
                let msg: String = "\(error.localizedDescription)"
                throw CapgoCapacitorDataStorageSqliteError.failed(message: msg)
            }
        } else {
            let message = "Must open a store first"
            throw CapgoCapacitorDataStorageSqliteError
            .failed(message: message)
        }
    }
}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
