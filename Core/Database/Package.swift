// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Database",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Database",
            targets: ["Database"]
        )
    ],
    dependencies: [
        .package(path: "../Model")
    ],
    targets: [
        .target(
            name: "Database",
            dependencies: [
                .product(name: "Model", package: "Model")
            ]
        ),
        .testTarget(
            name: "DatabaseTests",
            dependencies: [
                "Database",
                .product(name: "Model", package: "Model"),
            ]
        )
    ]
)
