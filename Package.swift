// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StartPoint",
    platforms: [
        .iOS(.v17),
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "StartPoint",
            targets: ["StartPoint"]),
    ],
    dependencies: [
        .package(url: "https://github.com/devicekit/DeviceKit.git", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "StartPoint",
            dependencies: [
                .product(name: "DeviceKit", package: "DeviceKit", condition: .when(platforms: [.iOS]))
            ]),
        .testTarget(
            name: "StartPointTests",
            dependencies: ["StartPoint"]),
    ]

)
