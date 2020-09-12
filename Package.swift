// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "{{name}}",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "Run",
            targets: ["Run"]
        ),
        .executable(
            name: "Run-long-polling",
            targets: ["Run-long-polling"]
        ),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),{{#fluent}}
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-{{fluent.db.url}}-driver.git", from: "{{fluent.db.version}}"),{{/fluent}}
        .package(url: "https://github.com/dmoroz0v/ChatBotSDK.git", .exact("0.0.6")),
        .package(url: "https://github.com/dmoroz0v/TgBotSDK.git", .exact("0.0.9")),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [{{#fluent}}
                .product(name: "Fluent", package: "fluent"),
                .product(name: "Fluent{{fluent.db.module}}Driver", package: "fluent-{{fluent.db.url}}-driver"),{{/fluent}}
                .product(name: "Vapor", package: "vapor"),
                "ChatBotSDK",
                "TgBotSDK",
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .target(name: "Run", dependencies: [.target(name: "App")]),
        .target(name: "Run-long-polling", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
