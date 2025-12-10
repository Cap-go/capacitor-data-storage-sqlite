// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapgoCapacitorDataStorageSqlite",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "CapgoCapacitorDataStorageSqlite",
            targets: ["CapgoCapacitorDataStorageSqlitePlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0"),
        .package(url: "https://github.com/zhuorantan/SQLiteCipher.git", from: "0.0.1")
    ],
    targets: [
        .target(
            name: "CapgoCapacitorDataStorageSqlitePlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "SQLiteCipher", package: "SQLiteCipher")
            ],
            path: "ios/Sources/CapgoCapacitorDataStorageSqlitePlugin"),
        .testTarget(
            name: "CapgoCapacitorDataStorageSqlitePluginTests",
            dependencies: ["CapgoCapacitorDataStorageSqlitePlugin"],
            path: "ios/Tests/CapgoCapacitorDataStorageSqlitePluginTests")
    ]
)
