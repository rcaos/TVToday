//
//  ShowDetailsDependencies.swift
//  ShowDetails
//
//  Created by Jeans Ruiz on 6/28/20.
//
//
//import UIKit
//import Shared
//import Networking
//import Persistence
//
//public struct ModuleDependencies {
//  
//  let apiDataTransferService: DataTransferService
//  let imagesBaseURL: String
//  let showsPersistenceRepository: ShowsVisitedLocalRepository
//  
//  public init(apiDataTransferService: DataTransferService,
//              imagesBaseURL: String,
//              showsPersistenceRepository: ShowsVisitedLocalRepository) {
//    self.apiDataTransferService = apiDataTransferService
//    self.imagesBaseURL = imagesBaseURL
//    self.showsPersistenceRepository = showsPersistenceRepository
//  }
//}
//

import UIKit
import Shared
import ShowDetailsInterface

public struct Module: ModuleShowDetailsBuilder {

  private let diContainer: DIContainer

  public init(dependencies: ModuleDependencies) {
    self.diContainer = DIContainer(dependencies: dependencies)
  }

  public func buildModuleCoordinator(in navigationController: UINavigationController,
                                     delegate: TVShowDetailCoordinatorDelegate?) -> NavigationCoordinator {
                                     //delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinator {
    return diContainer.buildModuleCoordinator(navigationController: navigationController, delegate: delegate)
  }
}
