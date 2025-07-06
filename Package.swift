// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "terminal-utilities",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "TerminalUtilities", targets: ["TerminalUtilities"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "TerminalUtilities",
            path: "Sources/terminal-utilities"
        ),
        .executableTarget(
            name: "terminal-utilities-cli",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "TerminalUtilities")
            ],
            path: "Sources/cli"
        ),
    ]
)
