// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MDBModels",
  platforms: [
    .iOS(.v13)
  ],
  products: [
    .library(
      name: "MDBModels",
      targets: ["MDBModels"]
    ),
    .library(
      name: "MDBModelsMocks",
      targets: ["MDBModelsMocks"]
    )
  ],
  dependencies: [
    .package(path: "../MDBDataLayer")
  ],
  targets: [
    .target(
      name: "MDBModels",
      dependencies: [
        "MDBDataLayer"
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .target(
      name: "MDBModelsMocks",
      dependencies: [
        "MDBModels"
      ],
      path: "Tests/MDBModelsMocks"
    )
  ]
)
