// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HacoCMSiOSSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "HacoCMSiOSSDK",
            targets: ["HacoCMSiOSSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0"))
    ],
    targets: [
        .target(
            name: "HacoCMSiOSSDK",
            dependencies: [
                "Moya"
            ],
            path: "HacoCMSiOSSDK/Sources"
        ),
    ]
)
