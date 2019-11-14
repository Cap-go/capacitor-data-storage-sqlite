//
//  StorageDatabaseHelper.swift
//  Plugin
//
//  Created by  Quéau Jean Pierre on 16/06/2019.
//  Copyright © 2019 Max Lynch. All rights reserved.
//

import Foundation
import SQLite
class StorageDatabaseHelper {
    var databaseName: String
    var tableName: String
    var tableStorage: Table
//    let DATABASE_NAME: String = "storageSQLite.db"
    let TABLE_INDEX: Table = Table("sqlite_sequence")
    let IDX_COL_NAME: Expression<String> = Expression<String>("name")
    let IDX_COL_SEQ: Expression<Int64> = Expression<Int64>("seq")
//    let TABLE_STORAGE_NAME = "storage_table"
//    let TABLE_STORAGE: Table = Table("storage_table")
    let COL_ID: Expression<Int64> = Expression<Int64>("id")
    let COL_NAME: Expression<String> = Expression<String>("name")
    let COL_VALUE: Expression<String> = Expression<String>("value")
    // define the path for the database
    let path: String = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    init(databaseName: String,tableName: String) {
        print("databaseName: \(databaseName) ")
        print("tableName: \(tableName) ")
        print("path: \(path)")
        self.databaseName = databaseName
        self.tableName = tableName
        self.tableStorage = Table(tableName)

        // connect to the database (create if doesn't exist)
        guard let db = try? Connection("\(path)/\(databaseName)") else {
            let error:String = "init: Error Database connection failed"
            print(error)
            return
        }
        // create table
        _ = createTable(db:db,tableName:tableName);


    }
    func getWritableDatabase() -> Connection? {
        guard let db = try? Connection("\(path)/\(databaseName)") else {return nil}
        return db
    }
    func getReadableDatabase() -> Connection? {
        guard let db = try? Connection("\(path)/\(databaseName)", readonly: true) else {return nil}
        return db
    }
    func setTable(tblName: String) -> Bool {
        guard let db: Connection = getWritableDatabase() else {return false}
        let res: Bool = createTable(db:db,tableName:tblName);
        if res {
            tableName = tblName;
            tableStorage = Table(tableName)
        }
        return res
    }

    func set(data:Data) -> Bool {
        var ret: Bool = false
        guard let db: Connection = getWritableDatabase() else {return false}
        // check if the data already exists
        if iskey(name: data.name!) {
            ret = updateData(data: data)
        } else {
            do {
                try db.run(tableStorage.insert(
                    COL_NAME <- data.name!,
                    COL_VALUE <- data.value!
                ))
                ret = true
            } catch let error {
                print("set: Error Data insertion failed: \(error)")
            }
        }
        return ret
    }
    func updateData(data:Data) -> Bool {
        var ret: Bool = false
        guard let db: Connection = getWritableDatabase() else {return false}
        let mFilter = tableStorage.filter(COL_NAME == data.name!)
        do {
            if try db.run(mFilter.update(COL_VALUE <- data.value!)) > 0 {
                ret = true
            } else {
                print("updateData: Error \(COL_NAME) not found")
            }
        } catch let error {
            print("updateData: Error update failed: \(error)")
        }
        return ret
    }
    func remove(name:String) -> Bool {
        var ret: Bool = false
        guard let db: Connection = getWritableDatabase() else {return false}
        let mFilter = tableStorage.filter(COL_NAME == name)
        do {
            if try db.run(mFilter.delete()) > 0 {
                ret = true
            } else {
                print("deleteDataByName: Error \(COL_NAME) not found")
            }
        } catch let error {
            print("deleteDataByName: Error delete failed: \(error)")
        }
        return ret
    }
    
    func clear() -> Bool {
        var ret: Bool = false
        guard let db: Connection = getWritableDatabase() else {return false}
        do {
            try db.run(tableStorage.delete())
            ret = resetIndex()
        } catch let error {
            print("deleteAllData: Error All data delete failed: \(error)")
        }
        return ret
    }
    
    func resetIndex() -> Bool {
        var ret: Bool = false
        guard let db: Connection = getWritableDatabase() else {return false}
        let idxFilter = TABLE_INDEX.filter(IDX_COL_NAME == tableName).limit(1)
        do {
            if try db.run(idxFilter.update(IDX_COL_SEQ <- 0)) > 0{
                ret = true
            } else {
                print("resetIndex: Error did not update the index" )
            }
        } catch let error {
            print("resetIndex: Error Index update failed: \(error)")
        }
        return ret
    }
    func get(name:String) -> Data? {
        var retData: Data = Data()
        guard let db: Connection = getReadableDatabase() else {return nil}
        let query = tableStorage.filter(COL_NAME == name).limit(1)
        guard let rData = try? db.prepare(query) else {return nil}
        for data in rData {
            retData.id = data[COL_ID]
            retData.name = data[COL_NAME]
            retData.value = data[COL_VALUE]
        }
        return retData
    }
    
    func keysvalues() -> Array<Data>? {
        var retArray: Array<Data> = Array<Data>()
        guard let db: Connection = getReadableDatabase() else {return nil}
        guard let retData: AnySequence<Row> = try? db.prepare(tableStorage) else { return nil}
        for rData in retData {
            var data = Data()
            data.id = rData[COL_ID]
            data.name = rData[COL_NAME]
            data.value = rData[COL_VALUE]
            retArray.append(data)
        }
        return retArray
    }
    
    func iskey(name:String) -> Bool {
        var ret: Bool = false
        // check if the key already exists
        if (get(name: name))!.id != nil {
            ret = true
        }
        return ret
    }
    
    func keys() -> Array<String>? {
        var retArray: Array<String> = Array<String>()
        guard let db: Connection = getReadableDatabase() else {return nil}
        guard let retData: AnySequence<Row> = try? db.prepare(tableStorage) else { return nil}
        for rData in retData {
            retArray.append(rData[COL_NAME])
        }
        return retArray
    }
    
    func values() -> Array<String>? {
        var retArray: Array<String> = Array<String>()
        guard let db: Connection = getReadableDatabase() else {return nil}
        guard let retData: AnySequence<Row> = try? db.prepare(tableStorage) else { return nil}
        for rData in retData {
            retArray.append(rData[COL_VALUE])
        }
        return retArray
    }
    private func createTable (db: Connection, tableName: String ) -> Bool {
        let tableStorage = Table(tableName);
        do {
            try db.run(tableStorage.create(ifNotExists: true) { t in
                t.column(COL_ID, primaryKey: .autoincrement)
                t.column(COL_NAME,unique: true)
                t.column(COL_VALUE)
            })
            // index COL_NAME
            do {
                try db.run(tableStorage.createIndex(COL_NAME, ifNotExists: true))
                
            } catch let error {
                print("init: Error Index creation failed: \(error)")
                return false
            }
        } catch let error {
            print("init: Error Table creation failed: \(error)")
            return false
        }
        return true
    }
}

