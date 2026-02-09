// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Design",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Design",
            targets: ["Design"]
        ),
    ],
    targets: [
        .target(
            name: "Design",
            resources: [
                .process("Resource")
            ]
        ),

    ]
)
