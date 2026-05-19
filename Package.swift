// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenLayout",
    platforms: [.macOS(.v15)],
    products: [
        .library(
            name: "OpenLayout",
            targets: ["OpenLayout"]
        ),
        .library(
            name: "OpenLayoutDSL",
            targets: ["OpenLayoutDSL"]
        ),
    ],
    targets: [
        .target(
            name: "OpenLayout"
        ),
        .target(
            name: "OpenLayoutDSL",
            dependencies: ["OpenLayout"]
        ),
        .testTarget(
            name: "OpenLayoutTests",
            dependencies: ["OpenLayout", "OpenLayoutDSL"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
