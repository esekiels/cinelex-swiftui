// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Splash",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Splash",
            targets: ["Splash"]
        )
    ],
    dependencies: [
        .package(path: "../../Core/Navigation"),
        .package(path: "../../Core/Design"),
        .package(path: "../../Core/Common")
    ],
    targets: [
        .target(
            name: "Splash",
            dependencies: [
                .product(name: "Navigation", package: "Navigation"),
                .product(name: "Design", package: "Design"),
                .product(name: "Common", package: "Common")
            ]
        )
    ]
)
