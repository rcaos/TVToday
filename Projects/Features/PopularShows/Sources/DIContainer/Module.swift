//
//  PopularShowsDependencies.swift
//  PopularShows
//
//  Created by Jeans Ruiz on 6/28/20.
//

import Foundation
import UIKit
import Networking
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
  
  public func buildPopularCoordinator(in navigationController: UINavigationController, delegate: PopularCoordinatorDelegate?) -> Coordinator {
    return diContainer.buildPopularCoordinator(navigationController: navigationController, delegate: delegate)
  }
}
