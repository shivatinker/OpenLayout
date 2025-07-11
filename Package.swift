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
        .library(
            name: "OpenLayoutDSL",
            targets: ["OpenLayoutDSL"]
        ),
        .library(
            name: "OpenLayoutCore",
            targets: ["OpenLayoutCore"]
        ),
        .library(
            name: "OpenLayoutText",
            targets: ["OpenLayoutText"]
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
            name: "OpenLayoutText",
            dependencies: ["OpenLayout"]
        ),
        .target(
            name: "OpenLayoutCore"
        ),
        .testTarget(
            name: "OpenLayoutTests",
            dependencies: [
                "OpenLayout",
                "OpenLayoutText"
            ]
        ),
    ]
)
