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
    .library(name: "UI", targets: ["UI"]),
    .library(name: "Networking", targets: ["Networking"]),
    .library(name: "NetworkingInterface", targets: ["NetworkingInterface"])
  ],
  dependencies: [

  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        // TODO, check graph here
        "UI",
        "Networking",
        "NetworkingInterface"
      ]),
    .testTarget(name: "AppFeatureTests", dependencies: ["AppFeature"]),
    .target(name: "UI", resources: [.process("Resources/")]),
    .target(name: "Networking", dependencies: ["NetworkingInterface"]),
    .testTarget(name: "NetworkingTests", dependencies: ["Networking"]),
    .target(name: "NetworkingInterface")
  ]
)
