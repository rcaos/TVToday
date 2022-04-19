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
    .library(name: "KeyChainStorage", targets: ["KeyChainStorage"]),
    .library(name: "Networking", targets: ["Networking"]),
    .library(name: "NetworkingInterface", targets: ["NetworkingInterface"]),
    .library(name: "UI", targets: ["UI"])
  ],
  dependencies: [
    .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "14.0.0")
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        // TODO, check graph here
        "KeyChainStorage",
        "Networking",
        "NetworkingInterface",
        "UI",
      ]),
    .testTarget(name: "AppFeatureTests", dependencies: ["AppFeature"]),
    .target(
      name: "KeyChainStorage",
      dependencies: [
        .product(name: "KeychainSwift", package: "keychain-swift")
      ]
    ),
    .target(name: "Networking", dependencies: ["NetworkingInterface"]),
    .testTarget(name: "NetworkingTests", dependencies: ["Networking"]),
    .target(name: "NetworkingInterface"),
    .target(name: "UI", resources: [.process("Resources/")]),
  ]
)
