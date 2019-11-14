//
//  Plugin.swift
//  Plugin
//
//  Created by  Quéau Jean Pierre on 16/06/2019.
//  Copyright © 2019 Max Lynch. All rights reserved.
//
import Foundation
import Capacitor
/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(CapacitorDataStorageSqlite)
public class CapacitorDataStorageSqlite: CAPPlugin {
    
//    let mDb:StorageDatabaseHelper = StorageDatabaseHelper()
    var mDb: StorageDatabaseHelper?

    @objc func openStore(_ call: CAPPluginCall) {
        let dbName = call.options["database"] as? String ?? "storage"
        let tableName = call.options["table"] as? String ?? "storage_table"
        mDb = StorageDatabaseHelper(databaseName:"\(dbName)SQLite.db",tableName:tableName)
        if(mDb != nil) {
            call.success([
                "result": true
            ])
        } else {
            call.reject("No database connection")
        }
    }    
    @objc func setTable(_ call: CAPPluginCall) {
        guard let tableName = call.options["table"] as? String else {
            call.reject("Must provide a table name")
            return
        }
        var res: Bool = false;
        var message: String = "";
        if(mDb != nil) {
            res = mDb!.setTable(tblName:tableName)
            if (!res) {
                message = "failed in adding table";
            }
        } else {
            message = "Must open a store first";
        }
        call.success(["result" : res , "message" : message])
    }    
    @objc func set(_ call: CAPPluginCall) {
        var data: Data = Data()
        guard let key = call.options["key"] as? String else {
            call.reject("Must provide a key")
            return
        }
        data.name = key
        guard let value = call.options["value"] as? String else {
            call.reject("Must provide a value")
            return
        }
        data.value = value
        let res: Bool = mDb!.set(data:data)
        
        call.resolve([
            "result": res
            ])
    }
    
    @objc func get(_ call: CAPPluginCall) {
        guard let key = call.options["key"] as? String else {
            call.reject("Must provide a key")
            return
        }
        let data: Data = mDb!.get(name:key)!
        if data.id != nil {
            call.resolve([
                "value": data.value!
                ])
            
        } else {
            var ret: Int? = 1
            ret = nil
            call.resolve([
                "value": ret as Any
            ])
        }
    }
    
    @objc func remove(_ call: CAPPluginCall) {
        guard let key = call.options["key"] as? String else {
            call.reject("Must provide a key")
            return
        }
        let result = mDb!.remove(name:key)
        call.resolve([
            "result": result
            ])
    }
    
    @objc func clear(_ call: CAPPluginCall) {
        let result = mDb!.clear()
        call.resolve([
            "result": result
            ])
    }
    
    @objc func iskey(_ call: CAPPluginCall) {
        guard let key = call.options["key"] as? String else {
            call.reject("Must provide a key")
            return
        }
        let result = mDb!.iskey(name:key)
        call.resolve([
            "result": result
            ])
    }
    
    @objc func keys(_ call: CAPPluginCall) {
        let result = mDb!.keys()
        call.resolve([
            "keys": result!
            ])
    }
    
    @objc func values(_ call: CAPPluginCall) {
        let result = mDb!.values()
        call.resolve([
            "values": result!
            ])
    }
    
    @objc func keysvalues(_ call: CAPPluginCall) {
        let results = mDb!.keysvalues()
        var dic: Array<Any> = []
        for result in results! {
            let res = ["key" : result.name, "value" : result.value]
            dic.append(res)
        }
        call.resolve([
            "keysvalues": dic
            ])
    }
    
}
