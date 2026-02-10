// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Data",
            targets: ["Data"]
        )
    ],
    dependencies: [
        .package(path: "../Network"),
        .package(path: "../Database"),
        .package(path: "../Model"),
        .package(path: "../Common")
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: [
                .product(name: "Network", package: "Network"),
                .product(name: "Database", package: "Database"),
                .product(name: "Model", package: "Model"),
                .product(name: "Common", package: "Common")
            ]
        )
    ]
)
