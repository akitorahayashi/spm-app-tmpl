// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Packages",
    platforms: [
        .iOS("16.0"),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "CounterFeature",
            targets: ["CounterFeature"]),
    ],
    targets: [
        .target(
            name: "CounterFeature",
            path: "CounterFeature/Sources/CounterFeature"
        ),
        .testTarget(
            name: "CounterFeatureTests",
            dependencies: ["CounterFeature"],
            path: "CounterFeature/Tests/CounterFeatureTests"
        ),
    ]
)
