// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KingfisherSVG",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "KingfisherSVG",
            targets: ["KingfisherSVG"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: "7.0.0"))
    ],
    targets: [
        .target(
            name: "KingfisherSVG",
            dependencies: [
                "Kingfisher"
            ]
        ),
        .testTarget(
            name: "KingfisherSVGTests",
            dependencies: ["KingfisherSVG"]
        )
    ]
)
