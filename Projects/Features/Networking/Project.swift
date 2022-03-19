import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "Networking",
  interfaceFolder: "Interface",
  interfaceDependencies: [
    // MARK: - TODO, remove soon
    .package(product: "RxSwift")
  ],
  testFolder: "Tests"
)
