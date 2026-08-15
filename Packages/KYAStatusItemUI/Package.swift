// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "KYAStatusItemUI",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "KYAStatusItemUI", targets: ["KYAStatusItemUI"]),
    ],
    dependencies: [
        .package(name: "KYAApplicationSupport", path: "../KYAApplicationSupport"),
    ],
    targets: [
        .target(
            name: "KYAStatusItemUI",
            dependencies: [
                "KYAApplicationSupport"
            ]
        ),
    ]
)
