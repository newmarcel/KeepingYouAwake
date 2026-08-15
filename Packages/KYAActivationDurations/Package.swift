// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "KYAActivationDurations",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "KYAActivationDurations", targets: ["KYAActivationDurations"]),
    ],
    dependencies: [
        .package(name: "KYACommon", path: "../KYACommon"),
    ],
    targets: [
        .target(
            name: "KYAActivationDurations",
            dependencies: [
                .product(name: "KYACommon", package: "KYACommon"),
            ]
        ),
        .testTarget(name: "KYAActivationDurationsTests", dependencies: ["KYAActivationDurations"]),
    ],
    cxxLanguageStandard: .cxx2b
)
