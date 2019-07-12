import PackageDescription

let package = Package(
    name: "BeatChain",
    products: [
        .library(name: "BeatChain", targets: ["BeatChain"]),
    ],
    targets: [
        .target(name: "BeatChain", path: "BeatChain"),
        .testTarget(name: "BeatChainTests", dependencies: ["BeatChain"]),
    ]
)