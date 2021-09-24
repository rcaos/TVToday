//
//  SearchShowDependencies.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import UIKit
import Networking
import Persistence
import Shared

public struct ModuleDependencies {
  
  let apiDataTransferService: DataTransferService
  let imagesBaseURL: String
  let showsPersistence: ShowsVisitedLocalRepository
  let searchsPersistence: SearchLocalRepository
  
  public init(apiDataTransferService: DataTransferService,
              imagesBaseURL: String,
              showsPersistence: ShowsVisitedLocalRepository,
              searchsPersistence: SearchLocalRepository) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
    self.showsPersistence = showsPersistence
    self.searchsPersistence = searchsPersistence
  }
}

// MARK: - Entry to Module

public struct Module {
  
  private let diContainer: DIContainer
  
  public init(dependencies: ModuleDependencies) {
    self.diContainer = DIContainer(dependencies: dependencies)
  }
  
  public func buildSearchCoordinator(in navigationController: UINavigationController) -> Coordinator {
    return diContainer.buildModuleCoordinator(navigationController: navigationController)
  }
}
