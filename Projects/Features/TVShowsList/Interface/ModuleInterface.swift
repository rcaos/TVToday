//
//  Module.swift
//  TVShowsList
//
//  Created by Jeans Ruiz on 6/27/20.
//

import UIKit
import Networking
import Shared
import ShowDetailsInterface

public struct ModuleDependencies {
  
  public let apiDataTransferService: DataTransferService
  public let imagesBaseURL: String
  public let showDetailsBuilder: ModuleShowDetailsBuilder
  
  public init(apiDataTransferService: DataTransferService,
              imagesBaseURL: String,
              showDetailsBuilder: ModuleShowDetailsBuilder) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
    self.showDetailsBuilder = showDetailsBuilder
  }
}

public protocol ModuleShowListDetailsBuilder {
  func buildModuleCoordinator(in navigationController: UINavigationController,
                              delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinatorProtocol
}

public protocol TVShowListCoordinatorProtocol: NavigationCoordinator {
  func navigate(to step: TVShowListStep)
}

public protocol TVShowListCoordinatorDelegate {
  func tvShowListCoordinatorDidFinish()
}

// MARK: - Steps
public enum TVShowListStep: Step {
  case genreList(genreId: Int, title: String?)
  case favoriteList
  case watchList
  case showIsPicked(showId: Int,
                    stepOrigin: TVShowListStepOrigin?,
                    closure: (_ updated: TVShowUpdated) -> Void)
  case showListDidFinish
}

// MARK: - Steps Origin
public enum TVShowListStepOrigin {
  case favoriteList
  case watchList
}
