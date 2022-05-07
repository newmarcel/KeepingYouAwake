// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "KYAActivationDurations",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        .library(name: "KYAActivationDurations", targets: ["KYAActivationDurations"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "KYAActivationDurations", dependencies: []),
        .testTarget(name: "KYAActivationDurationsTests", dependencies: ["KYAActivationDurations"]),
    ],
    cxxLanguageStandard: .cxx17
)
