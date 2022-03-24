import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "TVShowsList",
  interfaceFolder: "Interface",
  interfaceDependencies: [
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
      target: "ShowDetailsInterface",
      path: .relativeToRoot("Projects/Features/ShowDetails")
    )
  ],
  testFolder: "Tests",
  testDependencies: [
    .package(product: "SnapshotTesting")
  ]
)
