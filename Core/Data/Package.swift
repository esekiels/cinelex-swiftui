// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Data",
            targets: ["Data"]
        ),
    ],
    targets: [
        .target(
            name: "Data"
        ),

    ]
)
