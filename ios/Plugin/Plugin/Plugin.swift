import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(CapacitorDataStorageSqlite)
public class CapacitorDataStorageSqlite: CAPPlugin {
    
    let mDb:StorageDatabaseHelper = StorageDatabaseHelper()
    
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
        let cleanValue = value.replacingOccurrences(of: "\\", with: "\\");
        
        data.value = cleanValue
        let res: Bool = mDb.set(data:data)

        call.resolve([
            "result": res
        ])
    }
    
    @objc func get(_ call: CAPPluginCall) {
        guard let key = call.options["key"] as? String else {
            call.reject("Must provide a key")
            return
        }
        let data: Data = mDb.get(name:key)!
        if data.id != nil {
            call.resolve([
                "value": data.value!
            ])

        } else {
            call.resolve(["result":false])
        }
    }
    
    @objc func remove(_ call: CAPPluginCall) {
        guard let key = call.options["key"] as? String else {
            call.reject("Must provide a key")
            return
        }
        let result = mDb.remove(name:key)
        call.resolve([
            "result": result
        ])
    }

    @objc func clear(_ call: CAPPluginCall) {
        let result = mDb.clear()
        call.resolve([
            "result": result
        ])
    }
    
    @objc func iskey(_ call: CAPPluginCall) {
        guard let key = call.options["key"] as? String else {
            call.reject("Must provide a key")
            return
        }
        let result = mDb.iskey(name:key)
        call.resolve([
            "result": result
        ])
    }
    
    @objc func keys(_ call: CAPPluginCall) {
        let result = mDb.keys()
        call.resolve([
            "keys": result!
        ])
    }
    
    @objc func values(_ call: CAPPluginCall) {
        let result = mDb.values()
        call.resolve([
            "values": result!
        ])
    }
    
    @objc func keysvalues(_ call: CAPPluginCall) {
        let results = mDb.keysvalues()
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
