import Foundation
import Capacitor

// swiftlint:disable file_length
// swiftlint:disable type_body_length
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

    // swiftlint:disable function_body_length
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
                .openStore(dbName,
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
    // swiftlint:enable function_body_length

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
                call: call,
                message: "remove: Must provide a key")
            return
        }
        do {
            try implementation.remove(key)
            retHandler.rResult(call: call)
            return
        } catch CapacitorDataStorageSqliteError
                    .failed(let message) {
            let msg = "remove: \(message)"
            retHandler.rResult(call: call, message: msg)
            return
        } catch let error {
            let msg = "remove: \(error.localizedDescription)"
            retHandler.rResult(call: call, message: msg)
            return
        }

    }

    // MARK: - Clear

    @objc func clear(_ call: CAPPluginCall) {

        do {
            try implementation.clear()
            retHandler.rResult(call: call)
            return
        } catch CapacitorDataStorageSqliteError
                    .failed(let message) {
            let msg = "clear: \(message)"
            retHandler.rResult(call: call, message: msg)
            return
        } catch let error {
            let msg = "clear: \(error.localizedDescription)"
            retHandler.rResult(call: call, message: msg)
            return
        }
    }

    // MARK: - IsKey

    @objc func iskey(_ call: CAPPluginCall) {
        guard let key = call.options["key"] as? String else {
            retHandler.rResult(
                call: call, ret: false,
                message: "remove: Must provide a key")
            return
        }
        do {
            let res = try implementation.iskey(key)
            let ret = res == 1 ? true : false
            retHandler.rResult(call: call, ret: ret)
            return
        } catch CapacitorDataStorageSqliteError
                    .failed(let message) {
            let msg = "iskey: \(message)"
            retHandler.rResult(call: call, ret: false, message: msg)
            return
        } catch let error {
            let msg = "iskey: \(error.localizedDescription)"
            retHandler.rResult(call: call, ret: false, message: msg)
            return
        }

    }

    // MARK: - Keys

    @objc func keys(_ call: CAPPluginCall) {
        do {
            let ret = try implementation.keys()
            retHandler.rDict(call: call, ret: ["keys": ret])
        } catch CapacitorDataStorageSqliteError
                    .failed(let message) {
            let msg = "keys: \(message)"
            retHandler.rDict(call: call, ret: ["keys": []], message: msg)
            return
        } catch let error {
            let msg = "keys: \(error.localizedDescription)"
            retHandler.rDict(call: call, ret: ["keys": []], message: msg)
            return
        }
    }

    // MARK: - Values

    @objc func values(_ call: CAPPluginCall) {
        do {
            let ret = try implementation.values()
            retHandler.rDict(call: call, ret: ["values": ret])
        } catch CapacitorDataStorageSqliteError
                    .failed(let message) {
            let msg = "values: \(message)"
            retHandler.rDict(call: call, ret: ["values": []], message: msg)
            return
        } catch let error {
            let msg = "values: \(error.localizedDescription)"
            retHandler.rDict(call: call, ret: ["values": []], message: msg)
            return
        }
    }

    // MARK: - FilterValues

    @objc func filtervalues(_ call: CAPPluginCall) {
        guard let filter = call.options["filter"] as? String else {
            retHandler.rDict(
                call: call, ret: ["values": []],
                message: "remove: Must provide a filter")
            return
        }
        do {
            let ret = try implementation.filtervalues(filter: filter)
            retHandler.rDict(call: call, ret: ["values": ret])
        } catch CapacitorDataStorageSqliteError
                    .failed(let message) {
            let msg = "values: \(message)"
            retHandler.rDict(call: call, ret: ["values": []], message: msg)
            return
        } catch let error {
            let msg = "values: \(error.localizedDescription)"
            retHandler.rDict(call: call, ret: ["values": []], message: msg)
            return
        }
    }

    // MARK: - KeyValues

    @objc func keysvalues(_ call: CAPPluginCall) {
        do {
            let ret = try implementation.keysvalues()
            retHandler.rDict(call: call, ret: ["keysvalues": ret])
        } catch CapacitorDataStorageSqliteError
                    .failed(let message) {
            let msg = "keysvalues: \(message)"
            retHandler.rDict(call: call, ret: ["keysvalues": []],
                             message: msg)
            return
        } catch let error {
            let msg = "keysvalues: \(error.localizedDescription)"
            retHandler.rDict(call: call, ret: ["keysvalues": []],
                             message: msg)
            return
        }

    }

    // MARK: - DeleteStore

    @objc func deleteStore(_ call: CAPPluginCall) {
        let storeName = call.options["database"] as? String ?? "storage"
        do {
            try implementation.deleteStore(storeName: storeName)
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

    // MARK: - isTable

    @objc func isTable(_ call: CAPPluginCall) {
        guard let table = call.options["table"] as? String else {
            retHandler.rResult(
                call: call, ret: false,
                message: "remove: Must provide a table")
            return
        }
        do {
            let res = try implementation.isTable(table)
            let ret = res == 1 ? true : false
            retHandler.rResult(call: call, ret: ret)
            return
        } catch CapacitorDataStorageSqliteError
                    .failed(let message) {
            let msg = "istable: \(message)"
            retHandler.rResult(call: call, ret: false, message: msg)
            return
        } catch let error {
            let msg = "istable: \(error.localizedDescription)"
            retHandler.rResult(call: call, ret: false, message: msg)
            return
        }
    }

    // MARK: - tables

    @objc func tables(_ call: CAPPluginCall) {
        do {
            let ret = try implementation.tables()
            retHandler.rDict(call: call, ret: ["tables": ret])
        } catch CapacitorDataStorageSqliteError
                    .failed(let message) {
            let msg = "tables: \(message)"
            retHandler.rDict(call: call, ret: ["tables": []], message: msg)
            return
        } catch let error {
            let msg = "tables: \(error.localizedDescription)"
            retHandler.rDict(call: call, ret: ["tables": []], message: msg)
            return
        }
    }

    // MARK: - deleteTable

    @objc func deleteTable(_ call: CAPPluginCall) {
        guard let table = call.options["table"] as? String else {
            retHandler.rResult(
                call: call, ret: false,
                message: "remove: Must provide a table")
            return
        }
        do {
            try implementation.deleteTable(table)
            retHandler.rResult(call: call)
            return
        } catch CapacitorDataStorageSqliteError
                    .failed(let message) {
            let msg = "clear: \(message)"
            retHandler.rResult(call: call, message: msg)
            return
        } catch let error {
            let msg = "clear: \(error.localizedDescription)"
            retHandler.rResult(call: call, message: msg)
            return
        }
    }

}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
