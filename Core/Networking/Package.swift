// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]
        )
    ],
    dependencies: [
        .package(path: "../Model"),
        .package(path: "../Common")
    ],
    targets: [
        .target(
            name: "Networking",
            dependencies: [
                .product(name: "Model", package: "Model"),
                .product(name: "Common", package: "Common")
            ]
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: [
                "Networking",
                .product(name: "Model", package: "Model"),
                .product(name: "Common", package: "Common")
            ],
            resources: [
                .process("Resource")
            ]
        )
    ]
)
