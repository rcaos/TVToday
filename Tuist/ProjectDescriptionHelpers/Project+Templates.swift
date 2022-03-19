import ProjectDescription

private let deploymentTarget = ProjectDescription.DeploymentTarget.iOS(targetVersion: "14.0", devices: [.iphone])

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
    testFolder: String? = nil,
    testDependencies: [TargetDependency] = []
  ) -> Project {
    return project(
      name: name,
      packages: packages,
      product: .app,
      platform: platform,
      resources: resources,
      actions: actions + buildSwiftLintAction(),
      dependencies: dependencies + features.map {
        .project(
          target: $0,
          path: .relativeToRoot("Projects/Features/\($0)")
        )
      },
      infoPlist: buildInfoPlist(),
      settings: buildSettings(),
      testFolder: testFolder
    )
  }

  private static func buildInfoPlist() -> [String : InfoPlist.Value] {
    return [
      "API_KEY": "$(API_KEY)",
      "API_BASE_URL": "$(API_BASE_URL)",
      "IMAGE_BASE_URL": "$(IMAGE_BASE_URL)",

      "CFBundleShortVersionString": "1.0",
      "CFBundleVersion": "1",
      "UIMainStoryboardFile": "",
      "UILaunchStoryboardName": "LaunchScreen",
      "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": false
      ]
    ]
  }

  private static func buildSettings() -> Settings {
    let emptyBase: [String: SettingValue] = [:]
    let configuration: [CustomConfiguration] = [
      .debug(name: "Debug", xcconfig: Path("Config.xcconfig")),
      .release(name: "Release", xcconfig: Path("Config.xcconfig"))
    ]
    return Settings(base: emptyBase, configurations: configuration, defaultSettings: .recommended)
  }

  public static func framework(
    name: String,
    product: Product = .staticLibrary,
    platform: Platform = platform,
    //resources: [FileElement]? = nil,
    resources: ResourceFileElements? = nil,
    actions: [TargetAction] = [],
    dependencies: [TargetDependency] = [],
    interfaceFolder: String? = nil,
    interfaceDependencies: [TargetDependency] = [],
    testFolder: String? = nil,
    testDependencies: [TargetDependency] = []
  ) -> Project {
    return project(
      name: name,
      product: product,
      platform: platform,
      resources: resources,
      actions: actions + buildSwiftLintAction(for: "feature"),
      dependencies: dependencies,
      interfaceFolder: interfaceFolder,
      interfaceDependencies: interfaceDependencies,
      testFolder: testFolder,
      testDependencies: testDependencies
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
    settings: Settings? = nil,
    interfaceFolder: String? = nil,
    interfaceDependencies: [TargetDependency] = [],
    testFolder: String? = nil,
    testDependencies: [TargetDependency] = []
  ) -> Project {

    let targets = buildAppTargets(name: name,
                                  platform: platform,
                                  product: product,
                                  infoPlist: infoPlist,
                                  settings: settings,
                                  resources: resources,
                                  actions: actions,
                                  dependencies: dependencies,
                                  interfaceFolder: interfaceFolder,
                                  interfaceDependencies: interfaceDependencies,
                                  testFolder: testFolder,
                                  testDependencies: testDependencies)
    return Project(
      name: name,
      packages: packages,
      settings: settings,
      targets: targets,
      // Don't generate Assets.swift
      resourceSynthesizers: []
    )
  }

  // feature or empty for Main Project
  private static func buildSwiftLintAction(for projectType: String = "") -> [TargetAction] {
    [
      .pre(
        path: .relativeToRoot("Projects/BuildPhases/swiftlint.sh"),
        arguments: projectType,
        name: "SwiftLint"
      )
    ]
  }

  private static func buildAppTargets(name: String,
                                      platform: Platform,
                                      product: Product,
                                      infoPlist: [String: InfoPlist.Value] = [:],
                                      settings: Settings? = nil,
                                      resources: ResourceFileElements? = nil,
                                      actions: [TargetAction] = [],
                                      dependencies: [TargetDependency] = [],
                                      interfaceFolder: String? = nil,
                                      interfaceDependencies: [TargetDependency] = [],
                                      testFolder: String? = nil,
                                      testDependencies: [TargetDependency] = []
  ) -> [Target] {
    var targets: [Target] = []

    var mainDependencies: [TargetDependency] = dependencies

    if let interfaceFolder = interfaceFolder {
      targets.append (
        Target(
          name: "\(name)Interface",
          platform: platform,
          product: product,
          bundleId: "home.rcaos.\(name.lowercased()).interface",
          deploymentTarget: deploymentTarget,
          infoPlist: .extendingDefault(with: infoPlist),
          sources: ["\(interfaceFolder)/**"],
          resources: nil,  //???
          actions: [],
          dependencies: interfaceDependencies
        )
      )

      mainDependencies.append(
        .target(name: "\(name)Interface")
      )
    }

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
        dependencies: mainDependencies,
        settings: settings
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
          + testDependencies
        )
      )
    }

    return targets
  }
}
