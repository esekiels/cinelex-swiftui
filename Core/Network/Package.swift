// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Network",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Network",
            targets: ["Network"]
        )
    ],
    dependencies: [
        .package(path: "../Model"),
        .package(path: "../Common")
    ],
    targets: [
        .target(
            name: "Network",
            dependencies: [
                .product(name: "Model", package: "Model"),
                .product(name: "Common", package: "Common")
            ]
        ),
        .testTarget(
            name: "NetworkTests",
            dependencies: [
                "Network",
                .product(name: "Model", package: "Model"),
                .product(name: "Common", package: "Common")
            ],
            resources: [
                .process("Resource")
            ]
        )
    ]
)
