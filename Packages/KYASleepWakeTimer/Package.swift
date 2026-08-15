// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "KYASleepWakeTimer",
    platforms: [
        .macOS(.v12)
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
