//
//  ShowListDependencies.swift
//  TVShowsList
//
//  Created by Jeans Ruiz on 6/27/20.
//

import UIKit
import Shared
import TVShowsListInterface

public struct Module: ModuleShowListDetailsBuilder {
  
  private let diContainer: DIContainer
  
  public init(dependencies: ModuleDependencies) {
    self.diContainer = DIContainer(dependencies: dependencies)
  }

  public func buildModuleCoordinator(in navigationController: UINavigationController,
                                     delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinatorProtocol {
    return diContainer.buildModuleCoordinator(navigationController: navigationController, delegate: delegate)
  }
}
