// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenLayout",
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
            name: "Shapes",
            targets: ["Shapes"]
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
        .target(
            name: "Shapes",
            dependencies: ["OpenLayoutDSL"],
            path: "Examples/Shapes"
        ),
        .testTarget(
            name: "OpenLayoutTests",
            dependencies: ["OpenLayout", "OpenLayoutDSL", "Shapes"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
