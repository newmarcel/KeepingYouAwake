// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "KYAApplicationSupport",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "KYAApplicationSupport", targets: ["KYAApplicationSupport"]),
    ],
    dependencies: [
        .package(name: "KYACommon", path: "../KYACommon"),
    ],
    targets: [
        .target(
            name: "KYAApplicationSupport",
            dependencies: [
                .product(name: "KYACommon", package: "KYACommon"),
            ]
        ),
        .testTarget(
            name: "KYAApplicationSupportTests",
            dependencies: ["KYAApplicationSupport"],
            resources: [
                .copy("Resources/TestBundle.bundle"),
            ]
        ),
    ]
)
