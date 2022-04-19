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
    .library(name: "Shared", targets: ["Shared"]),
    .library(name: "UI", targets: ["UI"])
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "0.5.3"),
    .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "14.0.0"),
    .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.0.0")
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
        "Shared"
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
    .target(
      name: "Shared",
      dependencies: [
        "UI",
        "NetworkingInterface",
        "KeyChainStorage",
        .product(name: "Kingfisher", package: "Kingfisher"),
        .product(name: "CombineSchedulers", package: "combine-schedulers"),
      ],
      resources: [.process("Resources/")]),
  ]
)
