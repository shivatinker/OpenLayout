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
        .library(
            name: "RuneUI",
            targets: ["RuneUI"]
        ),
        .executable(
            name: "RuneDemo",
            targets: ["RuneDemo"]
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
            name: "RuneUI",
            dependencies: ["OpenLayout", "OpenLayoutDSL"],
            exclude: ["Examples"]
        ),
        .executableTarget(
            name: "RuneDemo",
            dependencies: ["RuneUI"],
            path: "Sources/RuneUI/Examples/RuneDemo"
        ),
        .testTarget(
            name: "OpenLayoutTests",
            dependencies: ["OpenLayout", "OpenLayoutDSL"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
