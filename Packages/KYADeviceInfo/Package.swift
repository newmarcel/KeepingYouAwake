// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "KYADeviceInfo",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .library(name: "KYADeviceInfo", targets: ["KYADeviceInfo"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "KYADeviceInfo", dependencies: []),
    ]
)
