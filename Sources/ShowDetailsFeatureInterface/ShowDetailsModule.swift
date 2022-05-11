//
//  DIContainer.swift
//  ShowDetails
//
//  Created by Jeans Ruiz on 8/12/20.
//

import UIKit
import Shared
import NetworkingInterface
import Persistence

public struct ModuleDependencies {

  public let apiDataTransferService: DataTransferService
  public let imagesBaseURL: String
  public let showsPersistenceRepository: ShowsVisitedLocalRepositoryProtocol

  public init(apiDataTransferService: DataTransferService,
              imagesBaseURL: String,
              showsPersistenceRepository: ShowsVisitedLocalRepositoryProtocol) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
    self.showsPersistenceRepository = showsPersistenceRepository
  }
}

public protocol ModuleShowDetailsBuilder {
  func buildModuleCoordinator(in navigationController: UINavigationController,
                              delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinatorProtocol
}

public protocol TVShowDetailCoordinatorDelegate: AnyObject {
  func tvShowDetailCoordinatorDidFinish()
}

public protocol TVShowDetailCoordinatorProtocol: NavigationCoordinator {
  func navigate(to step: ShowDetailsStep)
}

public enum ShowDetailsStep: Step {
  case showDetailsIsRequired(withId: Int, closures: TVShowDetailViewModelClosures? = nil)
  case seasonsAreRequired(withId: Int)
  case detailViewDidFinish
}

// MARK: - TODO, Move this 👇
public struct TVShowUpdated {
  public let showId: Int
  public let isActive: Bool

  public init(showId: Int, isActive: Bool) {
    self.showId = showId
    self.isActive = isActive
  }
}

public struct TVShowDetailViewModelClosures {

  public let updateFavoritesShows: ( (_ updated: TVShowUpdated) -> Void )?
  public let updateWatchListShows: ( (_ updated: TVShowUpdated) -> Void )?

  public init (updateFavoritesShows: ( (_ updated: TVShowUpdated) -> Void )? = nil ,
               updateWatchListShows: ( (_ updated: TVShowUpdated) -> Void )? = nil) {
    self.updateFavoritesShows = updateFavoritesShows
    self.updateWatchListShows = updateWatchListShows
  }
}
