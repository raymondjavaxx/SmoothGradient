// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "SmoothGradient",
    platforms: [
        .iOS(.v15),
        .macOS(.v11),
        .macCatalyst(.v13),
        .tvOS(.v14),
        .watchOS(.v7)
    ],
    products: [
        .library(
            name: "SmoothGradient",
            targets: ["SmoothGradient"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.11.0"
        )
    ],
    targets: [
        .target(
            name: "SmoothGradient"
        ),
        .testTarget(
            name: "SmoothGradientTests",
            dependencies: [
                "SmoothGradient",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        )
    ]
)
