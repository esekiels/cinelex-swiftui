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
        .package(path: "../../Core/Common")
    ],
    targets: [
        .target(
            name: "Network",
            dependencies: [
                .product(name: "Common", package: "Common")
            ]
        )
    ]
)
