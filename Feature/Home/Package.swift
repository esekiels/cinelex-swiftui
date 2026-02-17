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
        .package(path: "../Core/Data"),
        .package(path: "../Core/Datastore")
    ],
    targets: [
        .target(
            name: "Home",
            dependencies: [
                .product(name: "Details", package: "Details"),
                .product(name: "Data", package: "Data"),
                .product(name: "Datastore", package: "Datastore")
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
