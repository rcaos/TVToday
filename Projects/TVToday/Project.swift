import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "TVToday",
  packages: [
    //    .remote(
    //      url: "https://github.com/ReactiveX/RxSwift.git",
    //      requirement: .upToNextMajor(from: "6.2.0")
    //    ),
    //    .remote(
    //      url: "https://github.com/RxSwiftCommunity/RxDataSources.git",
    //      requirement: .upToNextMajor(from: "5.0.0")
    //    )
    .remote(
      url: "https://github.com/evgenyneu/keychain-swift.git",
      requirement: .upToNextMajor(from: "14.0.0")
    )
  ],
  resources: [
    "Resources/**"
  ],
  features: [
    "UI",
    "KeyChainStorage",
    "Persistence",
    //    "Feed"
  ],
  
  dependencies: [
    //    .project(
    //      target: "SosafeReactiveKit",
    //      path: .relativeToRoot("Projects/SosafeReactiveKit")
    //    ),
    //    .project(
    //      target: "SosafeReactiveKitUI",
    //      path: .relativeToRoot("Projects/SosafeReactiveKitUI")
    //    )
  ]
)
