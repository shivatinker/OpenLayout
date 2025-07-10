// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenLayout",
    platforms: [.macOS(.v13)],
    products: [
        .library(
            name: "OpenLayout",
            targets: ["OpenLayout"]
        ),
    ],
    targets: [
        .target(
            name: "OpenLayout",
            dependencies: ["OpenLayoutCore", "OpenLayoutDSL"]
        ),
        .target(
            name: "OpenLayoutDSL",
            dependencies: ["OpenLayoutCore"]
        ),
        .target(
            name: "OpenLayoutCore"
        ),
        .testTarget(
            name: "OpenLayoutTests",
            dependencies: ["OpenLayout"]
        ),
    ]
)
