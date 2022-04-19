// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TVToday",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "Networking", targets: ["Networking"]),
    .library(name: "NetworkingInterface", targets: ["NetworkingInterface"]),
  ],
  dependencies: [

  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        "Networking",
        "NetworkingInterface"
      ]),
    .testTarget(name: "AppFeatureTests", dependencies: ["AppFeature"]),
    .target(name: "Networking", dependencies: ["NetworkingInterface"]),
    .target(name: "NetworkingInterface")
  ]
)
