//
//  DIContainer.swift
//  ShowDetails
//
//  Created by Jeans Ruiz on 8/12/20.
//

import UIKit
import Shared
import Networking
import Persistence

public struct ModuleDependencies {

  public let apiDataTransferService: DataTransferService
  public let imagesBaseURL: String
  public let showsPersistenceRepository: ShowsVisitedLocalRepository

  public init(apiDataTransferService: DataTransferService,
              imagesBaseURL: String,
              showsPersistenceRepository: ShowsVisitedLocalRepository) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
    self.showsPersistenceRepository = showsPersistenceRepository
  }
}

public protocol ModuleShowDetailsBuilder {
  func buildModuleCoordinator(in navigationController: UINavigationController,
                               delegate: TVShowDetailCoordinatorDelegate?) -> NavigationCoordinator
}

public protocol TVShowDetailCoordinatorDelegate: AnyObject {
  func tvShowDetailCoordinatorDidFinish()
}
