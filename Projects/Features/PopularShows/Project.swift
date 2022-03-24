import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "PopularShows",
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
      target: "ShowDetailsInterface",
      path: .relativeToRoot("Projects/Features/ShowDetails")
    )
  ],
  testFolder: "Tests",
  testDependencies: [
    .package(product: "SnapshotTesting")
  ]
)
