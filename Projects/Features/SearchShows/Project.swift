import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "SearchShows",
  dependencies: [
    .project(
      target: "Networking",
      path: .relativeToRoot("Projects/Features/Networking")
    ),
    .project(
      target: "Shared",
      path: .relativeToRoot("Projects/Features/Shared")
    ),
    .project(
      target: "Persistence",
      path: .relativeToRoot("Projects/Features/Persistence")
    ),
    .project(
      target: "TVShowsListInterface",
      path: .relativeToRoot("Projects/Features/TVShowsList")
    ),
    .project(
      target: "ShowDetailsInterface",
      path: .relativeToRoot("Projects/Features/ShowDetails")
    ),
    .package(product: "RxSwift")
  ],
  testFolder: "Tests",
  testDependencies: [
    .package(product: "RxBlocking"),
    .package(product: "RxTest"),
    .package(product: "Quick"),
    .package(product: "Nimble"),
    .package(product: "SnapshotTesting")
  ]
)
