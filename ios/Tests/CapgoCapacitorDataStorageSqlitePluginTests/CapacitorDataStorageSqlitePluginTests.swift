import XCTest
@testable import CapgoCapacitorDataStorageSqlitePlugin

final class CapgoCapacitorDataStorageSqliteTests: XCTestCase {
    func testEcho() {
        // Ensure the basic iOS helper reflects the provided value.
        let implementation = CapgoCapacitorDataStorageSqlite()
        let value = "Hello, World!"
        let result = implementation.echo(value)

        XCTAssertEqual(value, result)
    }
}
