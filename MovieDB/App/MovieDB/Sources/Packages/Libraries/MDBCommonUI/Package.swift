// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MDBCommonUI",
  platforms: [
    .iOS(.v13)
  ],
  products: [
    .library(
      name: "MDBCommonUI",
      targets: ["MDBCommonUI"]
    ),
    .library(
      name: "MDBCommonUIMocks",
      targets: ["MDBCommonUIMocks"]
    )
  ],
  dependencies: [
    .package(path: "../MDBCommon"),
    .package(url: "https://github.com/roberthein/TinyConstraints.git", from: "4.0.2")
  ],
  targets: [
    .target(
      name: "MDBCommonUI",
      dependencies: [
        .product(name: "MDBCommon", package: "MDBCommon"),
        .product(name: "TinyConstraints", package: "TinyConstraints")
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .target(
      name: "MDBCommonUIMocks",
      dependencies: [
        "MDBCommonUI"
      ],
      path: "Tests/MDBCommonUIMocks"
    ),
    .testTarget(
      name: "MDBCommonUITests",
      dependencies: [
        "MDBCommonUIMocks"
      ],
      resources: [.process("Resources")]
    )
  ]
)
