// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Semver",
    platforms: [
        .iOS(.v13),
        .macOS("10.15"),
    ],
    products: [
        .library(
            name: "Semver",
            targets: ["Semver"])
    ],
    targets: [
        .target(
            name: "Semver",
            path: "Sources"),
        .testTarget(
            name: "SemverTests",
            dependencies: ["Semver"],
            path: "Tests")
    ],
    swiftLanguageVersions: [.version("5")]
)
