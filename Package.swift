// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "QLearningKit",
    products: [
        .library(
            name: "QLearningKit",
            targets: ["QLearningKit"]),
    ],
    targets: [
        .target(
            name: "QLearningKit"),
        .testTarget(
            name: "QLearningKitTests",
            dependencies: ["QLearningKit"]
        ),
    ]
)
