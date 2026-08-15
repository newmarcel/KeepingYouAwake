// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "KYAUserNotifications",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "KYAUserNotifications", targets: ["KYAUserNotifications"]),
    ],
    dependencies: [
        .package(name: "KYACommon", path: "../KYACommon"),
    ],
    targets: [
        .target(
            name: "KYAUserNotifications",
            dependencies: [
                .product(name: "KYACommon", package: "KYACommon"),
            ]
        ),
    ]
)
