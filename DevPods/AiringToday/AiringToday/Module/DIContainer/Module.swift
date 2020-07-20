//
//  AiringTodayDependencies.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 6/28/20.
//

import Foundation
import Networking
import Persistence
import Shared

public struct ModuleDependencies {
  
  let apiDataTransferService: DataTransferService
  let imagesBaseURL: String
  let showsPersistence: ShowsVisitedLocalRepository
  
  public init(apiDataTransferService: DataTransferService,
              imagesBaseURL: String,
              showsPersistence: ShowsVisitedLocalRepository) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
    self.showsPersistence = showsPersistence
  }
}

// MARK: - Entry to Module

public struct Module {
  
  private let diContainer: DIContainer
  
  public init(dependencies: ModuleDependencies) {
    self.diContainer = DIContainer(dependencies: dependencies)
  }
  
  public func buildAiringTodayCoordinator(in navigationController: UINavigationController) -> Coordinator {
    return diContainer.buildModuleCoordinator(navigationController: navigationController)
  }
}
