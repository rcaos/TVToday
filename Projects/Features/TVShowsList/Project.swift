import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "TVShowsList",
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
      target: "ShowDetails",
      path: .relativeToRoot("Projects/Features/ShowDetails")
    ),
    .package(product: "RxCocoa"),
    .package(product: "RxDataSources"),
    .package(product: "RxSwift"),
  ]
  // MARK: - TODO
  //,testFolder: "Tests"
)
