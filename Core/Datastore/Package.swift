// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Datastore",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Datastore",
            targets: ["Datastore"]
        )
    ],
    targets: [
        .target(
            name: "Datastore"
        )
    ]
)
