// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Sim",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Sim",
            targets: ["Sim"]),
        .library(
            name: "SimMacro",
            targets: ["SimMacro"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
      .package(url: "https://github.com/apple/swift-collections.git", branch: "release/1.1"),
      .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
      .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .macro(
          name: "SimMacroLibrary",
          dependencies: [
              .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
              .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
          ]
        ),

        .target(name: "SimMacro", dependencies: ["SimMacroLibrary"]),
        .target(
            name: "Sim",
            dependencies: [
              .product(name: "Collections",
                       package: "swift-collections"),
              .product(name: "OrderedCollections",
                       package: "swift-collections"),
              "SimMacro"
            ]),
        .testTarget(
            name: "SimTests",
            dependencies: ["Sim"]),

        .testTarget(
            name: "SimMacroTests",
            dependencies: [
                "SimMacroLibrary",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
