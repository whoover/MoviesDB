// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MDBServices",
  platforms: [
    .iOS(.v13)
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "MDBServices",
      targets: ["MDBServices"]
    ),
    .library(
      name: "MDBServicesMocks",
      targets: ["MDBServicesMocks"]
    )
  ],
  dependencies: [
    .package(path: "../MDBConstants"),
    .package(path: "../MDBNetworking"),
    .package(path: "../MDBUtilities"),
    .package(path: "../MDBModels"),
    .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.2"),
    .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", .exact("8.10.0"))
  ],
  targets: [
    .target(
      name: "MDBServices",
      dependencies: [
        "MDBConstants",
        .product(name: "FirebaseRemoteConfig", package: "Firebase"),
        .product(name: "FirebaseMessaging", package: "Firebase"),
        .product(name: "FirebaseAnalytics", package: "Firebase"),
        .product(name: "FirebasePerformance", package: "Firebase"),
        "MDBModels",
        "MDBNetworking",
        "MDBUtilities",
        "KeychainAccess"
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .target(
      name: "MDBServicesMocks",
      dependencies: [
        "MDBServices",
        .product(name: "MDBNetworkingMocks", package: "MDBNetworking")
      ],
      path: "Tests/MDBServicesMocks"
    ),
    .testTarget(
      name: "MDBServicesTests",
      dependencies: [
        "MDBServicesMocks",
        .product(name: "MDBModels", package: "MDBModels"),
        .product(name: "MDBModelsMocks", package: "MDBModels"),
        .product(name: "MDBNetworkingMocks", package: "MDBNetworking")
      ],
      resources: [
        .process("Resources")
      ]
    )
  ]
)
