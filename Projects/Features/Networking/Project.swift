import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "Networking",
  dependencies: [
    .project(
      target: "ReactiveKit",
      path: .relativeToRoot("Projects/ReactiveKit")
    )
  ]
)
