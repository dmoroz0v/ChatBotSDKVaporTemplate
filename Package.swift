// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "{{name}}",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.99.3"),{{#fluent}}
        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
        // {{fluent.db.emoji}} Fluent driver for {{fluent.db.module}}.
        .package(url: "https://github.com/vapor/fluent-{{fluent.db.url}}-driver.git", from: "{{fluent.db.version}}"),{{/fluent}}{{#leaf}}
        // 🍃 An expressive, performant, and extensible templating language built for Swift.
        .package(url: "https://github.com/vapor/leaf.git", from: "4.3.0"),{{/leaf}}
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        .package(url: "https://github.com/dmoroz0v/ChatBotSDK.git", from: "0.1.1"),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [{{#fluent}}
                .product(name: "Fluent", package: "fluent"),
                .product(name: "Fluent{{fluent.db.module}}Driver", package: "fluent-{{fluent.db.url}}-driver"),{{/fluent}}{{#leaf}}
                .product(name: "Leaf", package: "leaf"),{{/leaf}}
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "ChatBotSDK", package: "ChatBotSDK"),
                .product(name: "TgBotSDK", package: "ChatBotSDK"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "App"),
                .product(name: "XCTVapor", package: "vapor"),
                .product(name: "ChatBotSDK", package: "ChatBotSDK"),
                .product(name: "TgBotSDK", package: "ChatBotSDK"),
            ],
            swiftSettings: swiftSettings
        )
    ],
    swiftLanguageModes: [.v5]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableExperimentalFeature("StrictConcurrency"),
] }
