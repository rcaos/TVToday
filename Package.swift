// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TVToday",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "AccountFeature", targets: ["AccountFeature"]),
    .library(name: "AiringTodayFeature", targets: ["AiringTodayFeature"]),
    .library(name: "KeyChainStorage", targets: ["KeyChainStorage"]),
    .library(name: "Networking", targets: ["Networking"]),
    .library(name: "NetworkingInterface", targets: ["NetworkingInterface"]),
    .library(name: "Persistence", targets: ["Persistence"]),
    .library(name: "PersistenceLive", targets: ["PersistenceLive"]),
    .library(name: "PopularsFeature", targets: ["PopularsFeature"]),
    .library(name: "SearchShowsFeature", targets: ["SearchShowsFeature"]),
    .library(name: "Shared", targets: ["Shared"]),
    .library(name: "ShowDetailsFeature", targets: ["ShowDetailsFeature"]),
    .library(name: "ShowDetailsFeatureInterface", targets: ["ShowDetailsFeatureInterface"]),
    .library(name: "ShowListFeature", targets: ["ShowListFeature"]),
    .library(name: "ShowListFeatureInterface", targets: ["ShowListFeatureInterface"]),
    .library(name: "UI", targets: ["UI"]),
    .library(name: "AccountFeatureDemo", targets: ["AccountFeatureDemo"]),
    .library(name: "SearchShowsFeatureDemo", targets: ["SearchShowsFeatureDemo"]),
    .library(name: "ShowDetailsFeatureDemo", targets: ["ShowDetailsFeatureDemo"]),
    .library(name: "ShowListFeatureDemo", targets: ["ShowListFeatureDemo"])
  ],
  dependencies: [
    .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "14.0.0"),
    .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.9.1"),
    .package(url: "https://github.com/pointfreeco/combine-schedulers", .exactItem("0.5.3")),
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.14.1"),
    .package(url: "https://github.com/pointfreeco/swift-concurrency-extras.git", .rangeItem(.upToNextMajor(from: "1.0.0"))),
    .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.0")
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        "AccountFeature",
        "AiringTodayFeature",
        "KeyChainStorage",
        "Networking",
        "PersistenceLive",
        "PopularsFeature",
        "SearchShowsFeature",
        "Shared",
        "ShowDetailsFeature",
        "ShowListFeature",
        "UI"
      ]),
    .target(
      name: "AccountFeature",
      dependencies: [
        "Networking",
        "Shared",
        "ShowListFeatureInterface",
        "UI"
      ]
    ),
    .testTarget(
      name: "AccountFeatureTests",
      dependencies: [
        "AccountFeature",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
        .product(name: "ConcurrencyExtras", package: "swift-concurrency-extras")
      ],
      exclude: [
        "SignIn/Presentation/__Snapshots__",
        "Account/Presentation/__Snapshots__"
      ]
    ),
    .target(
      name: "AiringTodayFeature",
      dependencies: [
        "Networking",
        "Shared",
        "ShowDetailsFeatureInterface",
        "UI",
        .product(name: "Algorithms", package: "swift-algorithms")
      ]
    ),
    .testTarget(
      name: "AiringTodayFeatureTests",
      dependencies: [
        "AiringTodayFeature",
        "CommonMocks",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
      ],
      exclude: [
        "Presentation/SnapshotTests/__Snapshots__"
      ]
    ),
    .target(
      name: "KeyChainStorage",
      dependencies: [
        "Shared",
        .product(name: "KeychainSwift", package: "keychain-swift")
      ]
    ),
    .target(name: "Networking", dependencies: ["NetworkingInterface"]),
    .testTarget(
      name: "NetworkingTests",
      dependencies: [
        "Networking"
      ]
    ),
    .target(name: "NetworkingInterface"),
    .target(name: "Persistence", dependencies: ["Shared"]),
    .target(
      name: "PersistenceLive",
      dependencies: ["Persistence"],
      resources: [
        .copy("Internal/CoreDataStorage.xcdatamodeld")
      ]),
    .target(
      name: "PopularsFeature",
      dependencies: [
        "Networking",
        "Shared",
        "ShowDetailsFeatureInterface",
        "UI",
        .product(name: "Algorithms", package: "swift-algorithms")
      ]
    ),
    .testTarget(
      name: "PopularsFeatureTests",
      dependencies: [
        "PopularsFeature",
        "CommonMocks",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
      ],
      exclude: [
        "Presentation/SnapshotTests/__Snapshots__"
      ]
    ),
    .target(
      name: "SearchShowsFeature",
      dependencies: [
        "Networking",
        "Persistence",
        "Shared",
        "ShowDetailsFeatureInterface",
        "ShowListFeatureInterface",
        "UI",
        .product(name: "CombineSchedulers", package: "combine-schedulers")
      ]
    ),
    .testTarget(
      name: "SearchShowsFeatureTests",
      dependencies: [
        "SearchShowsFeature",
        "CommonMocks",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
      ],
      exclude: [
        "SearchOptions/Presentation/SnapshotTests/__Snapshots__",
        "SearchResults/Presentation/SnapshotTests/__Snapshots__"
      ]
    ),
    .target(
      name: "Shared",
      dependencies: [
        "NetworkingInterface",
        "Networking",
        .product(name: "Kingfisher", package: "Kingfisher"),
        .product(name: "CombineSchedulers", package: "combine-schedulers")
      ]
    ),
    .testTarget(
      name: "SharedTests",
      dependencies: [
        "Shared",
        "UI"
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
      ],
      exclude: [
        "DetailsScene/Presentation/View/__Snapshots__",
        "SeasonsScene/Presentation/View/__Snapshots__"
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
        "CommonMocks",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
      ],
      exclude: [
        "Presentation/SnapshotTests/__Snapshots__"
      ]
    ),
    .target(
      name: "ShowListFeatureInterface",
      dependencies: [
        "Networking",
        "Persistence",
        "Shared",
        "ShowDetailsFeatureInterface",
        "UI"
      ]
    ),
    .target(
      name: "UI",
      dependencies: [
        "Shared"
      ],
      resources: [
        .process("Resources/")
      ]
    ),

    // MARK: - Demo modules
    .target(name: "SearchShowsFeatureDemo", dependencies: ["SearchShowsFeature"]),
    .target(name: "AccountFeatureDemo", dependencies: ["AccountFeature"]),
    .target(name: "ShowDetailsFeatureDemo", dependencies: ["ShowDetailsFeature"]),
    .target(name: "ShowListFeatureDemo", dependencies: ["ShowListFeature"]),

    // MARK: - Common For test Targets
    .target(
      name: "CommonMocks",
      dependencies: [
        "Shared",
        "NetworkingInterface"
      ],
      path: "Tests/CommonMocks"
    ),
  ]
)
