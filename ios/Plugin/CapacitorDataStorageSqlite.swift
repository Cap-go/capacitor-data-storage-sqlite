import Foundation

enum CapacitorDataStorageSqliteError: Error {
    case failed(message: String)
}

@objc public class CapacitorDataStorageSqlite: NSObject {
    var mDb: StorageDatabaseHelper?

    // MARK: - Echo
    
    @objc public func echo(_ value: String) -> String {
        return value
    }

    // MARK: - OpenStore

    @objc func openStore(_ dbName: String, tableName: String,
                         encrypted: Bool, inMode: String,
                         secretKey: String, newsecretKey: String
                        ) throws {
        do {
            mDb = try StorageDatabaseHelper(
                            databaseName: "\(dbName)SQLite.db",
                            tableName: tableName,
                            encrypted: encrypted, mode: inMode,
                            secret: secretKey,
                            newsecret: newsecretKey)
        } catch StorageHelperError.initFailed(let message) {
            throw CapacitorDataStorageSqliteError
                                    .failed(message: message)
        } catch let error {
            throw CapacitorDataStorageSqliteError
                    .failed(message: error.localizedDescription)
        }
        if !(mDb?.isOpen ?? true) {
            throw CapacitorDataStorageSqliteError
                    .failed(message: "store not opened")
        } else {
            return
        }
    }

    // MARK: - setTable

    @objc func setTable(_ tableName: String) throws {

        if mDb != nil {
            do {
                try mDb?.setTable(tblName: tableName)
                return
            } catch StorageHelperError.setTable(let message) {
                throw CapacitorDataStorageSqliteError
                                        .failed(message: message)
            } catch let error {
                throw CapacitorDataStorageSqliteError
                        .failed(message: error.localizedDescription)
            }
        } else {
            let message = "Must open a store first"
            throw CapacitorDataStorageSqliteError
                                    .failed(message: message)
        }
    }
    
    // MARK: - set

    @objc func set(_ data: Any) throws {
        if mDb != nil {
            if let mData = data as? Data {
                do {
                    try mDb?.set(data: mData)
                } catch StorageHelperError.set(let message) {
                    throw CapacitorDataStorageSqliteError
                                    .failed(message: message)
                } catch let error {
                    let msg = error.localizedDescription
                    throw CapacitorDataStorageSqliteError
                            .failed(message: msg)
                }
            } else {
                let message = "data is not of type Data"
                throw CapacitorDataStorageSqliteError
                                    .failed(message: message)
            }
        } else {
            let message = "No database connection"
            throw CapacitorDataStorageSqliteError
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
                        let message = "No value returned"
                        throw CapacitorDataStorageSqliteError
                                                .failed(message: message)
                    }
                } else {
                    let message = "No Data returned"
                    throw CapacitorDataStorageSqliteError
                                            .failed(message: message)
                }
            } catch StorageHelperError.get(let message) {
                throw CapacitorDataStorageSqliteError
                                .failed(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw CapacitorDataStorageSqliteError
                        .failed(message: msg)
            }
        } else {
            let message = "No database connection"
            throw CapacitorDataStorageSqliteError
                                    .failed(message: message)
        }
    }
    @objc func remove(_ name: String) throws -> NSNumber {
        if mDb != nil {
            do {
                let result: Bool = ((try mDb?.remove(name: name)) != nil)
                if result {
                    return 1
                } else {
                    return 0
                }
            } catch StorageHelperError.remove(let message) {
                throw CapacitorDataStorageSqliteError
                                .failed(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw CapacitorDataStorageSqliteError
                        .failed(message: msg)
            }
        } else {
            let message = "No database connection"
            throw CapacitorDataStorageSqliteError
                                    .failed(message: message)
        }

    }
    @objc func clear() throws -> NSNumber {
        if mDb != nil {
            do {
                let result: Bool = ((try mDb?.clear()) != nil)
                if result {
                    return 1
                } else {
                    return 0
                }
            } catch StorageHelperError.clear(let message) {
                throw CapacitorDataStorageSqliteError
                                .failed(message: message)
            } catch let error {
                let msg = error.localizedDescription
                throw CapacitorDataStorageSqliteError
                        .failed(message: msg)
            }
        } else {
            let message = "No database connection"
            throw CapacitorDataStorageSqliteError
                                    .failed(message: message)
        }

    }
}
