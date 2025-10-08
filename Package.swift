// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapgoCapacitorDataStorageSqlite",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "CapgoCapacitorDataStorageSqlite",
            targets: ["CapgoCapacitorDataStorageSqlite"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.4.3"),
        .package(url: "https://github.com/stoneburner/SQLCipher.git", from: "0.0.4")
    ],
    targets: [
        .target(
            name: "CapgoCapacitorDataStorageSqlite",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "SQLCipher", package: "SQLCipher")
            ],
            path: "ios/Sources/CapgoCapacitorDataStorageSqlite",
        ),
        .testTarget(
            name: "CapgoCapacitorDataStorageSqliteTests",
            dependencies: ["CapgoCapacitorDataStorageSqlite"],
            path: "ios/Tests/CapgoCapacitorDataStorageSqliteTests",
        )
    ]
)
