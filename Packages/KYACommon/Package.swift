// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "KYACommon",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "KYACommon", targets: ["KYACommon"]),
    ],
    targets: [
        .target(name: "KYACommon"),
    ]
)
