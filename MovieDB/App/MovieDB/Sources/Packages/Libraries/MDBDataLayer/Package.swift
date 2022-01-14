// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MDBDataLayer",
  platforms: [
    .iOS(.v13)
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "MDBDataLayer",
      targets: ["MDBDataLayer"]
    ),
    .library(
      name: "MDBDataLayerMocks",
      targets: ["MDBDataLayerMocks"]
    )
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(name: "Realm", url: "https://github.com/realm/realm-cocoa", .exact("10.20.2")),
    .package(name: "NeedleFoundation", url: "https://github.com/uber/needle.git", .upToNextMajor(from: "0.17.2")),
    .package(path: "../MDBCommon")
  ],
  targets: [
    .target(
      name: "MDBDataLayer",
      dependencies: [
        .product(name: "RealmSwift", package: "Realm"),
        .product(name: "Realm", package: "Realm"),
        "NeedleFoundation",
        "MDBCommon"
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .target(
      name: "MDBDataLayerMocks",
      dependencies: [
        "MDBDataLayer"
      ],
      path: "Tests/MDBDataLayerMocks"
    ),
    .testTarget(
      name: "MDBDataLayerTests",
      dependencies: [
        "MDBDataLayerMocks"
      ],
      resources: [
        .process("Resources")
      ]
    )
  ]
)
