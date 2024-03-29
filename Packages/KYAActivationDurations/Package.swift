// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "KYAActivationDurations",
    platforms: [
        .macOS(.v10_13)
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
    cxxLanguageStandard: .cxx17
)
