// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "KYAStatusItemUI",
    platforms: [
        .macOS(.v10_13)
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
