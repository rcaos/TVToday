import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "Persistence",
  dependencies: [
    .project(
      target: "ReactiveKit",
      path: .relativeToRoot("Projects/ReactiveKit")
    )
  ]
)
