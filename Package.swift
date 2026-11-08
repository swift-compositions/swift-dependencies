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
            name: "Dependencies Foundation Integration",
            targets: ["Dependencies Foundation Integration"]
        ),
        .library(
            name: "Dependencies Environment Integration",
            targets: ["Dependencies Environment Integration"]
        ),
        .library(
            name: "Dependencies Test Support",
            targets: ["Dependencies Test Support"]
        ),
    ],
    traits: [
        .trait(name: "RFC4122", description: "RFC 4122 UUID integration"),
        .trait(name: "Time", description: "Time integration"),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-ascii.git", branch: "main", traits: ["Coder", "Parser", "Serializer"]),
        .package(url: "https://github.com/swift-atoms/swift-clock.git", branch: "main"),
        .package(url: "https://github.com/swift-compositions/swift-witnesses.git", branch: "main"),
        .package(url: "https://github.com/swift-compositions/swift-environment.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-4122.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-time.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-foundation-extensions.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-standard-library-extensions.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Dependencies",
            dependencies: [
                .product(name: "Clock Concurrency", package: "swift-clock"),
                .product(name: "Witnesses", package: "swift-witnesses"),
                .product(name: "Environment", package: "swift-environment"),
            ],
            path: "Sources/Dependencies"
        ),
        .target(
            name: "Dependencies RFC 4122 Integration",
            dependencies: [
                .target(name: "Dependencies"),
                .product(name: "Witnesses", package: "swift-witnesses", condition: .when(traits: ["RFC4122"])),
                .product(name: "RFC 4122", package: "swift-rfc-4122", condition: .when(traits: ["RFC4122"])),
            ],
            path: "Sources/Dependencies RFC 4122 Integration"
        ),
        .target(
            name: "Dependencies Time Integration",
            dependencies: [
                .target(name: "Dependencies"),
                .product(name: "Witnesses", package: "swift-witnesses", condition: .when(traits: ["Time"])),
                .product(name: "Time", package: "swift-time", condition: .when(traits: ["Time"])),
            ],
            path: "Sources/Dependencies Time Integration"
        ),
        .target(
            name: "Dependencies Foundation Integration",
            dependencies: [
                .target(name: "Dependencies"),
                .product(name: "FoundationEssentials Extensions", package: "swift-foundation-extensions"),
            ],
            path: "Sources/Dependencies Foundation Integration"
        ),
        .target(
            name: "Dependencies Environment Integration",
            dependencies: [
                .target(name: "Dependencies"),
                .product(name: "Environment", package: "swift-environment"),
            ],
            path: "Sources/Dependencies Environment Integration"
        ),
        .target(
            name: "Dependencies Test Support",
            dependencies: [
                .target(name: "Dependencies"),
                .product(name: "Witnesses", package: "swift-witnesses"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Dependencies Tests",
            dependencies: [
                .target(name: "Dependencies"),
                .target(name: "Dependencies Test Support"),
                .product(name: "Witnesses", package: "swift-witnesses"),
            ],
            path: "Tests/Dependencies Tests"
        ),
        .testTarget(
            name: "Dependencies Conformance Tests",
            dependencies: [
                .target(name: "Dependencies"),
                .product(name: "Clock Concurrency", package: "swift-clock"),
                .target(name: "Dependencies Test Support"),
                .product(name: "Witnesses", package: "swift-witnesses"),
            ],
            path: "Tests/Dependencies Conformance Tests"
        ),
        .testTarget(
            name: "Dependencies RFC 4122 Integration Tests",
            dependencies: [
                .target(name: "Dependencies RFC 4122 Integration"),
                .target(name: "Dependencies Test Support"),
            ],
            path: "Tests/Dependencies RFC 4122 Integration Tests"
        ),
        .testTarget(
            name: "Dependencies Time Integration Tests",
            dependencies: [
                .target(name: "Dependencies Time Integration"),
                .target(name: "Dependencies Test Support"),
            ],
            path: "Tests/Dependencies Time Integration Tests"
        ),
        .testTarget(
            name: "Dependencies Foundation Integration Tests",
            dependencies: [
                .target(name: "Dependencies Foundation Integration"),
                .target(name: "Dependencies Test Support"),
                .product(name: "Standard Library Extensions", package: "swift-standard-library-extensions"),
            ],
            path: "Tests/Dependencies Foundation Integration Tests"
        ),
        .testTarget(
            name: "Dependencies Environment Integration Tests",
            dependencies: [
                .target(name: "Dependencies Environment Integration"),
                .target(name: "Dependencies Test Support"),
            ],
            path: "Tests/Dependencies Environment Integration Tests"
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
