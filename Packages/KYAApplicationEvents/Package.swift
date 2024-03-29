// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "KYAApplicationEvents",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .library(name: "KYAApplicationEvents", targets: ["KYAApplicationEvents"]),
    ],
    dependencies: [
        .package(name: "KYACommon", path: "../KYACommon"),
    ],
    targets: [
        .target(
            name: "KYAApplicationEvents",
            dependencies: [
                .product(name: "KYACommon", package: "KYACommon"),
            ]
        ),
        .testTarget(name: "KYAApplicationEventsTests", dependencies: ["KYAApplicationEvents"]),
    ]
)
