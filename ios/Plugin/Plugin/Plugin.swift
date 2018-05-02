import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(CapacitorDataStorageSqlite)
public class CapacitorDataStorageSqlite: CAPPlugin {
    
    let mDb:StorageDatabaseHelper = StorageDatabaseHelper()
    
    @objc func saveData(_ call: CAPPluginCall) {
        var data: Data = Data()
        guard let name = call.options["name"] as? String else {
            call.error("Must provide a name")
            return
        }
        data.name = name
        guard let value = call.options["value"] as? String else {
            call.error("Must provide a value")
            return
        }
        data.value = value
        let res: Bool = mDb.addData(data:data)

        call.success([
            "result": res
            ])
    }
    
    @objc func getData(_ call: CAPPluginCall) {
        guard let name = call.options["name"] as? String else {
            call.error("Must provide a name")
            return
        }
        let data: Data = mDb.getDataByName(name:name)!
        if data.id != nil {
            call.success([
                "value": data.value!
            ])

        } else {
            call.error("No value found for name \(name)")
            return
        }
    }
    
    @objc func removeData(_ call: CAPPluginCall) {
        guard let name = call.options["name"] as? String else {
            call.error("Must provide a name")
            return
        }
        let result = mDb.deleteDataByName(name:name)
        call.success([
            "result": result
        ])
    }

    @objc func removeAllData(_ call: CAPPluginCall) {
        let result = mDb.deleteAllData()
        call.success([
            "result": result
        ])
    }
}
