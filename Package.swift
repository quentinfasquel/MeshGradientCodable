// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MeshGradientCodable",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .macCatalyst(.v13),
        .tvOS(.v16),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "MeshGradientCodable",
            targets: ["MeshGradientCodable"]),
    ],
    targets: [
        .target(
            name: "MeshGradientCodable",
            swiftSettings: swiftSettings()
        ),
    ]
)

func swiftSettings() -> [SwiftSetting] {
#if compiler(>=6)
    return [.define("SDK_IOS_18_MACOS_15")]
#else
    return []
#endif
}
