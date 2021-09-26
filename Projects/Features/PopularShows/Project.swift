import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "PopularShows",
  dependencies: [
    .project(
      target: "Networking",
      path: .relativeToRoot("Projects/Features/Networking")
    ),
    .project(
      target: "Shared",
      path: .relativeToRoot("Projects/Features/Shared")
    ),
    .package(product: "RxCocoa"),
    .package(product: "RxDataSources"),
    .package(product: "RxSwift"),
  ],
  testFolder: "Tests",
  testDependencies: [
    .package(product: "RxBlocking"),
    .package(product: "RxTest"),
    .package(product: "Quick"),
    .package(product: "Nimble")
  ]
)
