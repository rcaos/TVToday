// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TVToday",
  products: [
    .library(
      name: "AppFeature", targets: ["AppFeature"]
    )
  ],
  dependencies: [

  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [

      ]),
    .testTarget(name: "AppFeatureTests", dependencies: ["AppFeature"])
  ]
)
