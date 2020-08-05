import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(CapacitorDataStorageSqlite)
public class CapacitorDataStorageSqlite: CAPPlugin {

    var mDb: StorageDatabaseHelper?
    var globalData: Global = Global()

    // MARK: - Echo

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.success([
            "value": value
        ])
    }

    // MARK: - OpenStore

    @objc func openStore(_ call: CAPPluginCall) {
        let dbName = call.options["database"] as? String ?? "storage"
        let tableName = call.options["table"] as? String ?? "storage_table"
        let encrypted = call.options["encrypted"] as? Bool ?? false
        var inMode: String = ""
        var secretKey: String = ""
        var newsecretKey: String = ""
        if encrypted {
            inMode = call.options["mode"] as? String ?? "no-encryption"
            if inMode != "no-encryption" && inMode != "encryption"
                    && inMode != "secret" && inMode != "newsecret" && inMode != "wrongsecret" {
                call.resolve([
                    "result": false,
                    "message": "OpenStore: Error inMode must be in ['encryption','secret','newsecret'])"
                ])
            }
            if inMode == "encryption" || inMode == "secret" {
                secretKey = globalData.secret
            } else if inMode == "newsecret" {
                secretKey = globalData.secret
                newsecretKey = globalData.newsecret
                globalData.secret = newsecretKey
            } else if inMode == "wrongsecret" {
                secretKey = "wrongsecret"
                inMode = "secret"
            } else {
                secretKey = ""
                newsecretKey = ""
            }
        } else {
            inMode = "no-encryption"
        }
        do {
            mDb = try StorageDatabaseHelper(databaseName: "\(dbName)SQLite.db", tableName: tableName,
                                            encrypted: encrypted, mode: inMode, secret: secretKey,
                                            newsecret: newsecretKey)
        } catch let error {
            call.resolve([
                "result": false,
                "message": "Error: \(error)"
            ])
        }
        if !(mDb?.isOpen ?? true) {
            call.resolve(["result": false])
        } else {
            call.resolve(["result": true])
        }
    }

    // MARK: - SetTable

    @objc func setTable(_ call: CAPPluginCall) {
        guard let tableName = call.options["table"] as? String else {
            call.reject("setTable: Must provide a table name")
            return
        }
        var res: Bool = false
        var message: String = ""
        if mDb != nil {
            res = mDb?.setTable(tblName: tableName) ?? false
            if !res {
                message = "setTable: failed in adding table"
            }
        } else {
            message = "setTable: Must open a store first"
        }
        call.success(["result": res, "message": message])
    }

    // MARK: - Set

    @objc func set(_ call: CAPPluginCall) {
        var data: Data = Data()
        guard let key = call.options["key"] as? String else {
            call.reject("set: Must provide a key")
            return
        }
        data.name = key
        guard let value = call.options["value"] as? String else {
            call.reject("set: Must provide a value")
            return
        }
        data.value = value
        if mDb != nil {
            let res: Bool = mDb?.set(data: data) ?? false
                call.resolve(["result": res])
        } else {
            call.reject("set: No database connection")
            return
        }
    }

    // MARK: - Get

    @objc func get(_ call: CAPPluginCall) {
        guard let key = call.options["key"] as? String else {
            call.reject("get: Must provide a key")
            return
        }
        if mDb != nil {
            if let data: Data = mDb?.get(name: key) {
                guard (data.value) != nil else {
                    var ret: Int? = 1
                    ret = nil
                    call.resolve(["value": ret as Any])
                    return
                }
                call.resolve(["value": data.value as Any])
            } else {
                call.reject("get: Error in getting the key")
                return
            }
        } else {
            call.reject("get: No database connection")
            return
        }
    }

    // MARK: - Remove

    @objc func remove(_ call: CAPPluginCall) {
        guard let key = call.options["key"] as? String else {
            call.reject("Must provide a key")
            return
        }
        let result: Bool = mDb?.remove(name: key) ?? false
        call.resolve(["result": result])
    }

    // MARK: - Clear

    @objc func clear(_ call: CAPPluginCall) {
        let result: Bool = mDb?.clear() ?? false
        call.resolve(["result": result])
    }

    // MARK: - IsKey

    @objc func iskey(_ call: CAPPluginCall) {
        guard let key = call.options["key"] as? String else {
            call.reject("Must provide a key")
            return
        }
        let result: Bool = mDb?.iskey(name: key) ?? false
        call.resolve(["result": result])
    }

    // MARK: - Keys

    @objc func keys(_ call: CAPPluginCall) {
        guard let result = mDb?.keys() else {
            var ret: Int? = 1
            ret = nil
            call.resolve(["keys": ret as Any])
            return
        }
        call.resolve(["keys": result])
    }

    // MARK: - Values

    @objc func values(_ call: CAPPluginCall) {
        guard let result = mDb?.values() else {
            var ret: Int? = 1
            ret = nil
            call.resolve(["values": ret as Any])
            return
        }
        call.resolve(["values": result])
    }

    // MARK: - KeyValues

    @objc func keysvalues(_ call: CAPPluginCall) {
        guard let results = mDb?.keysvalues() else {
            var ret: Int? = 1
            ret = nil
            call.resolve(["keysvalues": ret as Any])
            return
        }
        var dic: [Any] = []
        for result in results {
            let res = ["key": result.name, "value": result.value]
            dic.append(res)
        }
        call.resolve(["keysvalues": dic])
    }

    // MARK: - DeleteStore

    @objc func deleteStore(_ call: CAPPluginCall) {
        let storeName = call.options["database"] as? String ?? "storage"
        do {
            let res: Bool = try (mDb?.deleteDB(databaseName: "\(storeName)SQLite.db")) ?? false
            call.success(["result": res])
        } catch StorageDatabaseHelperError.deleteStore {
            call.reject("Error in deleting store")
        } catch {
            call.reject("Unexpected error: \(error).")
        }

    }
}
