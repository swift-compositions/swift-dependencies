// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-dependencies",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Dependencies",
            targets: ["Dependencies"]
        ),
        .library(
            name: "Dependencies RFC 4122 Integration",
            targets: ["Dependencies RFC 4122 Integration"]
        ),
        .library(
            name: "Dependencies Time Integration",
            targets: ["Dependencies Time Integration"]
        ),
        .library(
            name: "Dependencies Test Support",
            targets: ["Dependencies Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-compositions/swift-witnesses.git", branch: "main"),
        .package(url: "https://github.com/swift-compositions/swift-environment.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-4122.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-time.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Dependencies",
            dependencies: [
                .product(name: "Witnesses", package: "swift-witnesses"),
                .product(name: "Environment", package: "swift-environment"),
            ],
            path: "Sources/Dependencies"
        ),
        .target(
            name: "Dependencies RFC 4122 Integration",
            dependencies: [
                "Dependencies",
                .product(name: "Witnesses", package: "swift-witnesses"),
                .product(name: "RFC 4122", package: "swift-rfc-4122"),
            ],
            path: "Sources/Dependencies RFC 4122 Integration"
        ),
        .target(
            name: "Dependencies Time Integration",
            dependencies: [
                "Dependencies",
                .product(name: "Witnesses", package: "swift-witnesses"),
                .product(name: "Time", package: "swift-time"),
            ],
            path: "Sources/Dependencies Time Integration"
        ),
        .target(
            name: "Dependencies Test Support",
            dependencies: [
                "Dependencies",
                .product(name: "Witnesses", package: "swift-witnesses"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Dependencies Tests",
            dependencies: [
                "Dependencies",
                "Dependencies Test Support",
                .product(name: "Witnesses", package: "swift-witnesses"),
            ],
            path: "Tests/Dependencies Tests"
        ),
        .testTarget(
            name: "Dependencies Conformance Tests",
            dependencies: [
                "Dependencies",
                "Dependencies Test Support",
                .product(name: "Witnesses", package: "swift-witnesses"),
            ],
            path: "Tests/Dependencies Conformance Tests"
        ),
        .testTarget(
            name: "Dependencies RFC 4122 Integration Tests",
            dependencies: [
                "Dependencies RFC 4122 Integration",
                "Dependencies Test Support",
            ],
            path: "Tests/Dependencies RFC 4122 Integration Tests"
        ),
        .testTarget(
            name: "Dependencies Time Integration Tests",
            dependencies: [
                "Dependencies Time Integration",
                "Dependencies Test Support",
            ],
            path: "Tests/Dependencies Time Integration Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
