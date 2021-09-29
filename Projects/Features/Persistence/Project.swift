import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "Persistence",
  dependencies: [
    .package(product: "RxSwift"),
    .project(
      target: "Shared",
      path: .relativeToRoot("Projects/Features/Shared")
    )
  ]
)
