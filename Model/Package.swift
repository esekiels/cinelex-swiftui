// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Model",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Model",
            targets: ["Model"])
    ],
    dependencies: [
        .package(name: "Base", path: "../Base")
    ],
    targets: [
        .target(
            name: "Model",
            dependencies: [
                .product(name: "Base", package: "Base")
            ],
            resources: [
                .copy("Resources/movie_list.json")
            ])
    ]
)
