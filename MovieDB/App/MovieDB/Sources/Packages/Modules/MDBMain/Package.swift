// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MDBMain",
  platforms: [
    .iOS(.v13)
  ],
  products: [
    .library(
      name: "MDBMain",
      targets: ["MDBMain"]
    ),
    .library(
      name: "MDBMainMocks",
      targets: ["MDBMainMocks"]
    )
  ],
  dependencies: [
    .package(path: "../../Libraries/MDBServices"),
    .package(path: "../../Libraries/MDBConstants"),
    .package(path: "../../Libraries/MDBComponents")
  ],
  targets: [
    .target(
      name: "MDBMain",
      dependencies: [
        "MDBServices",
        "MDBConstants",
        "MDBComponents"
      ]
    ),
    .target(
      name: "MDBMainMocks",
      dependencies: [
        .product(name: "MDBServicesMocks", package: "MDBServices"),
        "MDBMain"
      ],
      path: "Tests/MDBMainMocks"
    ),
    .testTarget(
      name: "MDBMainTests",
      dependencies: ["MDBMainMocks"]
    )
  ]
)
