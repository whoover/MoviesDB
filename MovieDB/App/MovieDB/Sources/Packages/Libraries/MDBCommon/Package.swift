// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MDBCommon",
  platforms: [
    .iOS(.v13)
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "MDBCommon",
      targets: ["MDBCommon"]
    ),
    .library(
      name: "MDBCommonMocks",
      targets: ["MDBCommonMocks"]
    )
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "MDBCommon",
      dependencies: [
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .target(
      name: "MDBCommonMocks",
      dependencies: [
        "MDBCommon"
      ],
      path: "Tests/MDBCommonMocks"
    ),
    .testTarget(
      name: "MDBCommonTests",
      dependencies: [
        "MDBCommonMocks"
      ],
      resources: [
        .process("Resources")
      ]
    )
  ]
)
