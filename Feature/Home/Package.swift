// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Home",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Home",
            targets: ["Home"]
        )
    ],
    dependencies: [
        .package(path: "../Details"),
        .package(path: "../Core/Data")
    ],
    targets: [
        .target(
            name: "Home",
            dependencies: [
                .product(name: "Details", package: "Details"),
                .product(name: "Data", package: "Data")
            ],
        ),
        .testTarget(
            name: "HomeTests",
            dependencies: [
                "Home",
                .product(name: "Data", package: "Data")
            ]
        )
    ]
)
