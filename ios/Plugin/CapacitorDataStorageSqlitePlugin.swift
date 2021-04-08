import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CapacitorDataStorageSqlitePlugin)
public class CapacitorDataStorageSqlitePlugin: CAPPlugin {
    private let implementation = CapacitorDataStorageSqlite()
    private let retHandler: ReturnHandler = ReturnHandler()

    var globalData: Global = Global()

    // MARK: - Echo


    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
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
                retHandler.rResult(
                    call: call,
                    message: "OpenStore: Error inMode must be in ['encryption','secret','newsecret'])")
                return
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
            try implementation
                .openStore("\(dbName)SQLite.db",
                           tableName: tableName,
                           encrypted: encrypted, inMode: inMode,
                           secretKey: secretKey,
                           newsecretKey: newsecretKey)
            retHandler.rResult(call: call)
            return
        } catch CapacitorDataStorageSqliteError
                                    .failed(let message) {
            let msg = "openStore: \(message)"
            retHandler.rResult(call: call, message: msg)
            return
        } catch let error {
            let msg = "openStore: \(error.localizedDescription)"
            retHandler.rResult(call: call, message: msg)
            return
        }
    }

    // MARK: - SetTable

    @objc func setTable(_ call: CAPPluginCall) {
        guard let tableName = call.options["table"] as? String
                                                    else {
            retHandler.rResult(
                call: call,
                message: "setTable: Must provide a table name")
            return
        }
        do {
            try implementation.setTable(tableName)
            retHandler.rResult(call: call)
            return
        } catch CapacitorDataStorageSqliteError
                                    .failed(let message) {
            let msg = "setTable: \(message)"
            retHandler.rResult(call: call, message: msg)
            return
        } catch let error {
            let msg = "setTable: \(error.localizedDescription)"
            retHandler.rResult(call: call, message: msg)
            return
        }
    }

    // MARK: - Set

    @objc func set(_ call: CAPPluginCall) {
        var data: Data = Data()
        guard let key = call.options["key"] as? String else {
            retHandler.rResult(
                call: call,
                message: "set: Must provide a key")
            return
        }
        data.name = key
        guard let value = call.options["value"] as? String
                                                else {
            retHandler.rResult(
                call: call,
                message: "set: Must provide a value")
            return
        }
        data.value = value
        do {
            try implementation.set(data)
            retHandler.rResult(call: call)
            return
        } catch CapacitorDataStorageSqliteError
                                    .failed(let message) {
            let msg = "set: \(message)"
            retHandler.rResult(call: call, message: msg)
            return
        } catch let error {
            let msg = "set: \(error.localizedDescription)"
            retHandler.rResult(call: call, message: msg)
            return
        }

    }

    // MARK: - Get

    @objc func get(_ call: CAPPluginCall) {
        guard let key = call.options["key"] as? String else {
            retHandler.rValue(
                call: call, ret: "",
                message: "get: Must provide a key")
            return
        }
        do {
            let ret = try implementation.get(key)
            retHandler.rValue(call: call, ret: ret)
            return
        } catch CapacitorDataStorageSqliteError
                                    .failed(let message) {
            let msg = "get: \(message)"
            retHandler.rValue(call: call, ret: "", message: msg)
            return
        } catch let error {
            let msg = "get: \(error.localizedDescription)"
            retHandler.rValue(call: call, ret: "", message: msg)
            return
        }

    }

    // MARK: - Remove

    @objc func remove(_ call: CAPPluginCall) {
        guard let key = call.options["key"] as? String else {
            retHandler.rResult(
                call: call, ret: false,
                message: "remove: Must provide a key")
            return
        }
        do {
            let res = try implementation.remove(key)
            let ret = res == 1 ? true : false
            retHandler.rResult(call: call, ret: ret)
            return
        } catch CapacitorDataStorageSqliteError
                                    .failed(let message) {
            let msg = "remove: \(message)"
            retHandler.rResult(call: call, ret: false, message: msg)
            return
        } catch let error {
            let msg = "remove: \(error.localizedDescription)"
            retHandler.rResult(call: call, ret: false, message: msg)
            return
        }

    }

    // MARK: - Clear

    @objc func clear(_ call: CAPPluginCall) {
        
        do {
            let res = try implementation.clear()
            let ret = res == 1 ? true : false
            retHandler.rResult(call: call, ret: ret)
            return
        } catch CapacitorDataStorageSqliteError
                                    .failed(let message) {
            let msg = "clear: \(message)"
            retHandler.rResult(call: call, ret: false, message: msg)
            return
        } catch let error {
            let msg = "clear: \(error.localizedDescription)"
            retHandler.rResult(call: call, ret: false, message: msg)
            return
        }
    }
/*
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

    // MARK: - FilterValues

    @objc func filtervalues(_ call: CAPPluginCall) {
        guard let filter = call.options["filter"] as? String else {
            call.reject("Must provide a filter")
            return
        }
        guard let result = mDb?.filtervalues(filter: filter) else {
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
        } catch StorageHelperError.deleteStore {
            call.reject("Error in deleting store")
        } catch {
            call.reject("Unexpected error: \(error).")
        }

    }
 */
}
