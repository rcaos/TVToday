import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "TVToday",
  packages: [
    .remote(
      url: "https://github.com/evgenyneu/keychain-swift.git",
      requirement: .upToNextMajor(from: "14.0.0")
    ),
    .remote(
      url: "https://github.com/onevcat/Kingfisher.git",
      requirement: .upToNextMajor(from: "7.0.0")
    ),
    .remote(
      url: "https://github.com/realm/realm-cocoa.git",
      requirement: .upToNextMajor(from: "10.5.2")
    ),
    .remote(
      url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
      requirement: .upToNextMajor(from: "1.9.0")
    ),
    .remote(
      url: "https://github.com/pointfreeco/combine-schedulers",
      requirement: .upToNextMajor(from: "0.5.3")
    )
  ],
  resources: [
    "Resources/**"
  ],
  features: [
    "UI",
    "KeyChainStorage",
    "Persistence",
    "Networking",
    "Shared",
    "RealmPersistence",
    "ShowDetails",
    "PopularShows",
    "AiringToday",
    "TVShowsList",
    "SearchShows",
    "Account"
  ],
  dependencies: []
)
