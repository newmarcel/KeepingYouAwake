// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "KYASleepWakeTimer",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .library(name: "KYASleepWakeTimer", targets: ["KYASleepWakeTimer"]),
    ],
    dependencies: [
        .package(name: "KYAApplicationSupport", path: "../KYAApplicationSupport")
    ],
    targets: [
        .target(name: "KYASleepWakeTimer", dependencies: ["KYAApplicationSupport"]),
    ]
)
