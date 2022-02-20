// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "KYAEvents",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        .library(name: "KYAEvents", targets: ["KYAEvents"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "KYAEvents", dependencies: []),
    ]
)
