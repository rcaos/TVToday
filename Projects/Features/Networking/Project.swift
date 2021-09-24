import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "Networking",
  dependencies: [
    .package(product: "RxSwift")
//    .project(
//      target: "ReactiveKit",
//      path: .relativeToRoot("Projects/ReactiveKit")
//    )
  ]
)
