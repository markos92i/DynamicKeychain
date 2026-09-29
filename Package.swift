// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "DynamicKeychain",
    platforms: [
        .macOS(.v15), .iOS(.v18),
    ],
    products: [
        .library(
            name: "DynamicKeychain",
            targets: ["DynamicKeychain"]),
    ],
    targets: [
        .target(
            name: "DynamicKeychain"),
        .testTarget(
            name: "DynamicKeychainTests",
            dependencies: ["DynamicKeychain"]
        ),
    ]
)
