// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "KYAApplicationEvents",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        .library(name: "KYAApplicationEvents", targets: ["KYAApplicationEvents"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "KYAApplicationEvents", dependencies: []),
    ]
)
