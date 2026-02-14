// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Search",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Search",
            targets: ["Search"]
        )
    ],
    dependencies: [
        .package(path: "../../Core/Data"),
        .package(path: "../../Core/Design"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "8.0.0"))
    ],
    targets: [
        .target(
            name: "Search",
            dependencies: [
                .product(name: "Data", package: "Data"),
                .product(name: "Design", package: "Design"),
                .product(name: "Kingfisher", package: "Kingfisher")
            ],
        )
    ]
)
