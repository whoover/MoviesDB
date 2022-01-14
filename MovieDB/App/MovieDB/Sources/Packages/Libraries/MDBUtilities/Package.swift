// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MDBUtilities",
  platforms: [
    .iOS(.v13)
  ],
  products: [
    .library(
      name: "MDBUtilities",
      targets: ["MDBUtilities"]
    ),
    .library(
      name: "MDBUtilitiesMocks",
      targets: ["MDBUtilitiesMocks"]
    )
  ],
  dependencies: [
    .package(path: "../MDBCommonUI"),
    .package(path: "../MDBConstants")
  ],
  targets: [
    .target(
      name: "MDBUtilities",
      dependencies: [
        "MDBCommonUI",
        "MDBConstants"
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .target(
      name: "MDBUtilitiesMocks",
      dependencies: [
        "MDBCommonUI",
        "MDBUtilities"
      ],
      path: "Tests/MDBUtilitiesMocks"
    ),
    .testTarget(
      name: "MDBUtilitiesTests",
      dependencies: [
        "MDBUtilitiesMocks"
      ],
      resources: [
        .process("Resources")
      ]
    )
  ]
)
