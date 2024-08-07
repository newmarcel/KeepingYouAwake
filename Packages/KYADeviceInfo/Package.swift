// swift-tools-version:5.9

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
