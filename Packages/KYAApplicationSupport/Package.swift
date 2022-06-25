// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "KYAApplicationSupport",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .library(name: "KYAApplicationSupport", targets: ["KYAApplicationSupport"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "KYAApplicationSupport", dependencies: []),
        .testTarget(
            name: "KYAApplicationSupportTests",
            dependencies: ["KYAApplicationSupport"],
            resources: [
                .copy("Resources/TestBundle.bundle"),
            ]
        ),
    ]
)
