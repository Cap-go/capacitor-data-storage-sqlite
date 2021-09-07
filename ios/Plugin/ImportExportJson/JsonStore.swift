//
//  JsonStore.swift
//  Plugin
//
//  Created by  Quéau Jean Pierre on 05/09/2021.
//  Copyright © 2021 Max Lynch. All rights reserved.
//

import Foundation
public struct JsonStore: Codable {
    let database: String
    let encrypted: Bool
    let tables: [JsonTable]

    public func show() {
        print("databaseName: \(database) ")
        print("encrypted: \(encrypted) ")
        print("Number of Tables: \(tables.count) ")
        for table in tables {
            table.show()
        }
    }
}

public struct JsonTable: Codable {
    let name: String
    let values: [JsonValue]

    public func show() {
        print("name: \(name) ")
        if values.count > 0 {
            print("Number of Values: \(values.count) ")
            for val in values {
                val.show()
            }
        }
    }
}

public struct JsonValue: Codable {
    let key: String
    let value: String

    public func show() {
        print("key: \(key) value: \(value)")
    }
}
