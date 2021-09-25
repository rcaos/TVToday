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
      target: "Persistence",
      path: .relativeToRoot("Projects/Features/Persistence")
    ),
    .project(
      target: "TVShowsList",
      path: .relativeToRoot("Projects/Features/TVShowsList")
    ),
    .package(product: "RxCocoa"),
    .package(product: "RxDataSources"),
    .package(product: "RxSwift"),
  ]
  // MARK: - TODO
  //,testFolder: "Tests"
)
