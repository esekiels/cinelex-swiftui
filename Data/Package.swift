// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Data",
            targets: ["Data"])
    ],
    dependencies: [
        .package(name: "Model", path: "../Model"),
        .package(name: "Network", path: "../Network")
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: [
                .product(name: "Model", package: "Model"),
                .product(name: "Network", package: "Network")
            ]
        )
    ]
)
