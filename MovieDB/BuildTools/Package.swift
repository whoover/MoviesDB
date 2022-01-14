// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "BuildTools",
            targets: ["BuildTools"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.49.0"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.45.1"),
        .package(url: "https://github.com/SwiftGen/SwiftGen.git", from: "6.5.1"),
        .package(url: "https://github.com/uber/mockolo.git", from: "1.1.2"),
        .package(name: "NeedleFoundation", url: "https://github.com/uber/needle.git", from: "0.17.2"),
    ],

    targets: [
        .target(
            name: "BuildTools",
            dependencies: [
                "NeedleFoundation",
                .product(name: "MockoloFramework", package: "Mockolo"),
            ],
            path: ""
        ),
    ]
)
