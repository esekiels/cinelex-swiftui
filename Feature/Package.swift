// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Feature",
    platforms: [
        .iOS(.v16)
       ],
    products: [
        .library(
            name: "Feature",
            targets: ["Feature"])
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "8.0.0")),
        .package(name: "Model", path: "../Model"),
        .package(name: "Data", path: "../Data"),
        .package(name: "Base", path: "../Base")
    ],
    targets: [
        .target(
            name: "Feature",
            dependencies: [
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "Model", package: "Model"),
                .product(name: "Data", package: "Data"),
                .product(name: "Base", package: "Base")
            ])
    ]
)
