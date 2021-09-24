import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "TVToday",
  packages: [
    .remote(
      url: "https://github.com/ReactiveX/RxSwift.git",
      requirement: .upToNextMajor(from: "6.2.0")
    ),
    .remote(
      url: "https://github.com/RxSwiftCommunity/RxDataSources.git",
      requirement: .upToNextMajor(from: "5.0.0")
    ),
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
    "TVShowsList"
  ],
  
  dependencies: [
    .project(
      target: "ReactiveKit",
      path: .relativeToRoot("Projects/ReactiveKit")
    ),
    .project(
      target: "ReactiveKitUI",
      path: .relativeToRoot("Projects/ReactiveKitUI")
    )
  ]
)
