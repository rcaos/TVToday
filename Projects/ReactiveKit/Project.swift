import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "ReactiveKit",
  dependencies: [
    .package(product: "RxSwift")
  ]
)
