//
//  ShowDetailsDependencies.swift
//  ShowDetails
//
//  Created by Jeans Ruiz on 6/28/20.
//

import UIKit
import Shared
import ShowDetailsFeatureInterface

public struct Module: ModuleShowDetailsBuilder {

  private let diContainer: DIContainer

  public init(dependencies: ModuleDependencies) {
    self.diContainer = DIContainer(dependencies: dependencies)
  }

  public func buildModuleCoordinator(in navigationController: UINavigationController,
                                     delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinatorProtocol {
    return diContainer.buildModuleCoordinator(navigationController: navigationController, delegate: delegate)
  }
}
