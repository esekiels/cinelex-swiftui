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
    targets: [
        .target(
            name: "Database"
        )
    ]
)
