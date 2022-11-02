// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "hacoCMSiOSSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "hacoCMSiOSSDK",
            targets: ["HacocmsSDKSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0"))
    ],
    targets: [
        .target(
            name: "HacocmsSDKSwift",
            dependencies: [
                "Moya"
            ],
            path: "HacocmsSDKSwift/Sources"
        ),
    ]
)
