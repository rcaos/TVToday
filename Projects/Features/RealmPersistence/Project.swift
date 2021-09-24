import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "RealmPersistence",
  dependencies: [
    .package(product: "Realm"),
    .package(product: "RealmSwift"),
    .project(
      target: "ReactiveKit",
      path: .relativeToRoot("Projects/ReactiveKit")
    ),
    .project(
      target: "Persistence",
      path: .relativeToRoot("Projects/Features/Persistence")
    )
  ]
)