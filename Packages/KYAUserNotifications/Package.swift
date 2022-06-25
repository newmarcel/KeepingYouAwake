// swift-tools-version:5.5

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
    ],
    targets: [
        .target(name: "KYAUserNotifications", dependencies: []),
    ]
)
