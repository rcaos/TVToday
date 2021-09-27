//
//  ShowListDependencies.swift
//  TVShowsList
//
//  Created by Jeans Ruiz on 6/27/20.
//

import UIKit
import Networking
import ShowDetailsInterface

public struct ModuleDependencies {
  
  let apiDataTransferService: DataTransferService
  let imagesBaseURL: String
  let showDetailsBuilder: ModuleShowDetailsBuilder
  
  public init(apiDataTransferService: DataTransferService,
              imagesBaseURL: String,
              showDetailsBuilder: ModuleShowDetailsBuilder) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
    self.showDetailsBuilder = showDetailsBuilder
  }
}

// MARK: - Entry to Module
public struct Module {
  
  private let diContainer: DIContainer
  
  public init(dependencies: ModuleDependencies) {
    self.diContainer = DIContainer(dependencies: dependencies)
  }

  // MARK: - Change to Protocol, Create Interface 🚫
  public func buildModuleCoordinator(in navigationController: UINavigationController) -> TVShowListCoordinator {
    return diContainer.buildModuleCoordinator(navigationController: navigationController)
  }
}
