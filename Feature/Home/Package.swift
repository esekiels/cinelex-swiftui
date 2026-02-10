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
        .package(path: "../../Core/Data"),
        .package(path: "../../Core/Design"),
        .package(path: "../../Core/Common"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "8.0.0"))
    ],
    targets: [
        .target(
            name: "Home",
            dependencies: [
                .product(name: "Data", package: "Data"),
                .product(name: "Design", package: "Design"),
                .product(name: "Common", package: "Common"),
                .product(name: "Kingfisher", package: "Kingfisher")
            ],
        )
    ]
)
