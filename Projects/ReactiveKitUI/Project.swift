import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "ReactiveKitUI",
  dependencies: [
    .package(product: "RxSwift"),
    .package(product: "RxCocoa"),
    .package(product: "RxDataSources"),
  ]
)
