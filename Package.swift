// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MNOVerificationPackage",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "MNO_Verification_Framework",
      targets: ["MNO_Verification_Framework"])
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .binaryTarget(
      name: "MNO_Verification_Framework",  // Name your binary target
      path: "MNO_Verification_Framework.xcframework"  // Path to your XCFramework
    ),
  ]
)
