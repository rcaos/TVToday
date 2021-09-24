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
      target: "TVShowsList",
      path: .relativeToRoot("Projects/Features/TVShowsList")
    ),
    .project(
      target: "ReactiveKitUI",
      path: .relativeToRoot("Projects/ReactiveKitUI")
    ),
  ]
  // MARK: - TODO
  //,testFolder: "Tests"
)