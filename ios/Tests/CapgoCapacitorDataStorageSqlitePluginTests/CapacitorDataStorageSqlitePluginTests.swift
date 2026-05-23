import XCTest
@testable import CapgoCapacitorDataStorageSqlitePlugin

final class CapgoCapacitorDataStorageSqliteTests: XCTestCase {
    func testOpenStoreCreatesFreshStore() throws {
        let storeName = uniqueStoreName(prefix: "plain")
        let fileName = "\(storeName)SQLite.db"
        let implementation = CapgoCapacitorDataStorageSqlite()

        try? UtilsFile.deleteFile(fileName: fileName)
        defer {
            try? implementation.closeStore(storeName)
            try? UtilsFile.deleteFile(fileName: fileName)
        }

        XCTAssertNoThrow(
            try implementation.openStore(
                storeName,
                tableName: "saveData",
                encrypted: false,
                inMode: "no-encryption"
            )
        )

        let exists = try implementation.isStoreExists(storeName)
        XCTAssertEqual(exists.intValue, 1)
    }

    func testOpenStoreCreatesFreshEncryptedStore() throws {
        let storeName = uniqueStoreName(prefix: "issue58")
        let fileName = "\(storeName)SQLite.db"
        let implementation = CapgoCapacitorDataStorageSqlite()

        try? UtilsFile.deleteFile(fileName: fileName)
        defer {
            try? implementation.closeStore(storeName)
            try? UtilsFile.deleteFile(fileName: fileName)
        }

        XCTAssertNoThrow(
            try implementation.openStore(
                storeName,
                tableName: "saveData",
                encrypted: true,
                inMode: "encryption"
            )
        )
        XCTAssertNoThrow(try implementation.closeStore(storeName))
        XCTAssertNoThrow(
            try implementation.openStore(
                storeName,
                tableName: "saveData",
                encrypted: true,
                inMode: "secret"
            )
        )
    }

    private func uniqueStoreName(prefix: String) -> String {
        let suffix = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        return "\(prefix)_\(suffix)"
    }
}
