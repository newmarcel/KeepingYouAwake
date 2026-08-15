// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "KYADeviceInfo",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "KYADeviceInfo", targets: ["KYADeviceInfo"]),
    ],
    dependencies: [
        .package(name: "KYACommon", path: "../KYACommon"),
    ],
    targets: [
        .target(
            name: "KYADeviceInfo",
            dependencies: [
                .product(name: "KYACommon", package: "KYACommon"),
            ]
        ),
    ]
)
