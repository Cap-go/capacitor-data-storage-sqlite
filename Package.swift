// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapgoCapacitorDataStorageSqlite",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CapgoCapacitorDataStorageSqlite",
            targets: ["CapgoCapacitorDataStorageSqlitePlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.4.2")
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.15.3")

    ],
    targets: [
        .target(
            name: "CapgoCapacitorDataStorageSqlitePlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "SQLite", package: "SQLite.swift/SQLCipher")
            ],
            path: "ios/Sources/CapgoCapacitorDataStorageSqlitePlugin"),
        .testTarget(
            name: "CapgoCapacitorDataStorageSqlitePluginTests",
            dependencies: ["CapgoCapacitorDataStorageSqlitePlugin"],
            path: "ios/Tests/CapgoCapacitorDataStorageSqlitePluginTests")
    ]
)
