// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "KYAUserNotifications",
    platforms: [
        .macOS(.v10_13)
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
