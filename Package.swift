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
    .library(name: "AccountFeature", targets: ["AccountFeature"]),
    .library(name: "KeyChainStorage", targets: ["KeyChainStorage"]),
    .library(name: "Networking", targets: ["Networking"]),
    .library(name: "NetworkingInterface", targets: ["NetworkingInterface"]),
    .library(name: "Persistence", targets: ["Persistence"]),
    .library(name: "Shared", targets: ["Shared"]),
    .library(name: "ShowDetailsFeature", targets: ["ShowDetailsFeature"]),
    .library(name: "ShowDetailsFeatureInterface", targets: ["ShowDetailsFeatureInterface"]),
    .library(name: "ShowListFeature", targets: ["ShowListFeature"]),
    .library(name: "ShowListFeatureInterface", targets: ["ShowListFeatureInterface"]),
    .library(name: "UI", targets: ["UI"])
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "0.5.3"),
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.9.0"),
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
        "Persistence",
        "Shared",
        "ShowDetailsFeature",
        "ShowListFeature",
        "UI"
      ]),
    .testTarget(name: "AppFeatureTests", dependencies: ["AppFeature"]),
    .target(
      name: "KeyChainStorage",
      dependencies: [
        .product(name: "KeychainSwift", package: "keychain-swift")
      ]
    ),
    .target(
      name: "AccountFeature",
      dependencies: [
        "Networking",
        "Shared",
        "ShowListFeatureInterface",
        "UI",
        .product(name: "CombineSchedulers", package: "combine-schedulers")
      ]
    ),
    .testTarget(
      name: "AccountFeatureTests",
      dependencies: [
        "AccountFeature",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
      ]
    ),
    .target(name: "Networking", dependencies: ["NetworkingInterface"]),
    .testTarget(name: "NetworkingTests", dependencies: ["Networking"]),
    .target(name: "NetworkingInterface"),
    .target(name: "Persistence", dependencies: ["Shared"]),
    .target(
      name: "Shared",
      dependencies: [
        "UI",
        "NetworkingInterface",
        "KeyChainStorage",
        .product(name: "Kingfisher", package: "Kingfisher"),
        .product(name: "CombineSchedulers", package: "combine-schedulers"),
      ],
      resources: [
        .process("Resources/")
      ]
    ),
    .target(
      name: "ShowDetailsFeature",
      dependencies: [
        "ShowDetailsFeatureInterface",
        "UI",
        .product(name: "CombineSchedulers", package: "combine-schedulers"),
      ]
    ),
    .testTarget(
      name: "ShowDetailsFeatureTests",
      dependencies: [
        "ShowDetailsFeature",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
      ]
    ),
    .target(
      name: "ShowDetailsFeatureInterface",
      dependencies: [
        "Networking", // MARK: - TODO, depends on Interface only
        "Shared",
        "Persistence"
      ]
    ),
    .target(
      name: "ShowListFeature",
      dependencies: [
        "ShowListFeatureInterface",
        .product(name: "CombineSchedulers", package: "combine-schedulers"),
      ]
    ),
    .testTarget(
      name: "ShowListFeatureTests",
      dependencies: [
        "ShowListFeature",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
      ]
    ),
    .target(
      name: "ShowListFeatureInterface",
      dependencies: [
        "Networking",
        "Shared",
        "Persistence",
        "ShowDetailsFeatureInterface"
      ]
    ),
    .target(name: "UI", resources: [.process("Resources/")]),
  ]
)
