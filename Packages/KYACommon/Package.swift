// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "KYACommon",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .library(name: "KYACommon", targets: ["KYACommon"]),
    ],
    targets: [
        .target(name: "KYACommon"),
    ]
)
