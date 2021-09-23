import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "KeyChainStorage",
  dependencies: [
    .package(product: "KeychainSwift")
  ])
