import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "AiringToday",
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
      target: "ShowDetailsInterface",
      path: .relativeToRoot("Projects/Features/ShowDetails")
    )
  ],
  testFolder: "Tests",
  testDependencies: [
    .package(product: "SnapshotTesting")
  ]
)
