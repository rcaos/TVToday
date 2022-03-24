import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "Account",
  dependencies: [
    .project(
      target: "UI",
      path: .relativeToRoot("Projects/Features/UI")
    ),
    .project(
      target: "Shared",
      path: .relativeToRoot("Projects/Features/Shared")
    ),
    .project(
      target: "Networking",
      path: .relativeToRoot("Projects/Features/Networking")
    ),
    .project(
      target: "TVShowsListInterface",
      path: .relativeToRoot("Projects/Features/TVShowsList")
    )
  ],
  testFolder: "Tests",
  testDependencies: [
    .package(product: "SnapshotTesting")
  ]
)
