import ProjectDescription

private let deploymentTarget = ProjectDescription.DeploymentTarget.iOS(targetVersion: "12.2", devices: [.iphone])

// MARK: - TODO:
// 1. Swiftlint script into Build Phases

extension Project {

  public static let platform: Platform = .iOS

  public static func app(
    name: String,
    packages: [Package] = [],
    platform: Platform = platform,
    //resources: [FileElement]? = nil, //??? Why in the other works with nil
    resources: ResourceFileElements? = nil,
    actions: [TargetAction] = [],
    features: [String] = [],
    dependencies: [TargetDependency] = [],
    testFolder: String? = nil
  ) -> Project {
    return project(
      name: name,
      packages: packages,
      product: .app,
      platform: platform,
      resources: resources,
      actions: actions,
      dependencies: dependencies + features.map {
        .project(
          target: $0,
          path: .relativeToRoot("Projects/Features/\($0)")
        )
      },
      infoPlist:
        [
          "CFBundleShortVersionString": "1.0",
          "CFBundleVersion": "1",
          "UIMainStoryboardFile": "",
          "UILaunchStoryboardName": "LaunchScreen",
          "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false
          ]
        ],
      testFolder: testFolder
    )
  }

  public static func framework(
    name: String,
    platform: Platform = platform,
    //resources: [FileElement]? = nil,
    resources: ResourceFileElements? = nil,
    actions: [TargetAction] = [],
    dependencies: [TargetDependency] = [],
    testFolder: String? = nil
  ) -> Project {
    return project(
      name: name,
      product: .framework,
      platform: platform,
      resources: resources,
      actions: actions,
      dependencies: dependencies,
      testFolder: testFolder
    )
  }

  public static func project(
    name: String,
    packages: [Package] = [],
    product: Product,
    platform: Platform = platform,
    //resources: [FileElement]? = nil, //??????
    resources: ResourceFileElements? = nil,
    actions: [TargetAction] = [],
    dependencies: [TargetDependency] = [],
    infoPlist: [String: InfoPlist.Value] = [:],
    testFolder: String? = nil
  ) -> Project {

    let targets = buildAppTargets(name: name,
                                  platform: platform,
                                  product: product,
                                  infoPlist: infoPlist,
                                  resources: resources,
                                  actions: actions,
                                  dependencies: dependencies,
                                  testFolder: testFolder)
    return Project(
      name: name,
      packages: packages,
      targets: targets,
      // Don't generate Assets.swift
      resourceSynthesizers: []
    )
  }

  private static func buildAppTargets(name: String,
                                      platform: Platform,
                                      product: Product,
                                      infoPlist: [String: InfoPlist.Value] = [:],
                                      resources: ResourceFileElements? = nil,
                                      actions: [TargetAction] = [],
                                      dependencies: [TargetDependency] = [],
                                      testFolder: String? = nil
  ) -> [Target] {
    var targets: [Target] = []

    targets.append (
      Target(
        name: name,
        platform: platform,
        product: product,
        bundleId: "home.rcaos.\(name.lowercased())",
        deploymentTarget: deploymentTarget,
        infoPlist: .extendingDefault(with: infoPlist),
        sources: ["Sources/**"],
        resources: resources,  //???
        //resources: ["Resources/**"],
        actions: actions,
        dependencies: dependencies
      )
    )

    if let testFolder = testFolder {
      targets.append (
        Target(
          name: "\(name)Tests",
          platform: platform,
          product: .unitTests,
          bundleId: "home.rcaos.\(name.lowercased())Tests",
          infoPlist: .default,
          //sources: "Tests/**",
          sources: "\(testFolder)/**",
          dependencies: [
            .target(name: "\(name)")
          ]
        )
      )
    }

    return targets
  }
}
