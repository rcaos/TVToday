//
//  AiringTodayDependencies.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 6/28/20.
//

import Foundation
import UIKit
import Networking
import Persistence
import Shared

public struct ModuleDependencies {
  
  let apiDataTransferService: DataTransferService
  let imagesBaseURL: String
  
  public init(apiDataTransferService: DataTransferService,
              imagesBaseURL: String) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
  }
}

// MARK: - Entry to Module
public struct Module {
  
  private let diContainer: DIContainer
  
  public init(dependencies: ModuleDependencies) {
    self.diContainer = DIContainer(dependencies: dependencies)
  }
  
  public func buildAiringTodayCoordinator(in navigationController: UINavigationController, delegate: AiringTodayCoordinatorDelegate?) -> Coordinator {
    return diContainer.buildModuleCoordinator(navigationController: navigationController, delegate: delegate)
  }
}
