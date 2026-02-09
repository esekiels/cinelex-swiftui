// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Common",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Common",
            targets: ["Common"]
        ),
    ],
    targets: [
        .target(
            name: "Common",
            resources: [
                .process("Resource")
            ]
        ),

    ]
)
