// swift-tools-version:6.1.2
import PackageDescription

enum Traits {
    static let SQLite = "SQLite"
    static let SQLCipher = "SQLCipher"
}

let package = Package(
    name: "sqlite-kit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13),
    ],
    products: [
        .library(name: "SQLiteKit", targets: ["SQLiteKit"]),
    ],
    traits: [
        .trait(name: Traits.SQLite, description: "Enable SQLite without encryption"),
        .trait(name: Traits.SQLCipher, description: "Enable SQLCipher encryption support for encrypted databases"),
        .default(enabledTraits: [])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        .package(url: "https://github.com/diokaratzas/sqlite-nio.git", branch: "feature/sql-cipher-2",  traits: [
            .trait(name: Traits.SQLite, condition: .when(traits: [Traits.SQLite])),
            .trait(name: Traits.SQLCipher, condition: .when(traits: [Traits.SQLCipher]))
        ]),
        .package(url: "https://github.com/vapor/sql-kit.git", from: "3.29.3"),
        .package(url: "https://github.com/vapor/async-kit.git", from: "1.19.0"),
    ],
    targets: [
        .target(
            name: "SQLiteKit",
            dependencies: [
                .product(name: "NIOFoundationCompat", package: "swift-nio"),
                .product(name: "AsyncKit", package: "async-kit"),
                .product(name: "SQLiteNIO", package: "sqlite-nio"),
                .product(name: "SQLKit", package: "sql-kit"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "SQLiteKitTests",
            dependencies: [
                .product(name: "SQLKitBenchmark", package: "sql-kit"),
                .target(name: "SQLiteKit"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
    .enableExperimentalFeature("StrictConcurrency=complete"),
] }
