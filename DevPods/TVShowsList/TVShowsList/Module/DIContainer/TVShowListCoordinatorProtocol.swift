//
//  TVShowListCoordinatorProtocol.swift
//  TVShowsList
//
//  Created by Jeans Ruiz on 8/12/20.
//

import Shared
import ShowDetails

public protocol TVShowListCoordinatorProtocol: class {
  
  func navigate(to step: TVShowListStep)
}

public protocol TVShowListCoordinatorDelegate: class {
  
  func tvShowListCoordinatorDidFinish()
}

// MARK: - Coordinator Dependencies

protocol TVShowListCoordinatorDependencies {
  
  func buildShowListViewController_ForGenres(with genreId: Int,
                                             coordinator: TVShowListCoordinatorProtocol,
                                             stepOrigin: TVShowListStepOrigin?) -> UIViewController
  
  func buildShowListViewController_ForFavorites(coordinator: TVShowListCoordinatorProtocol,
                                                stepOrigin: TVShowListStepOrigin?) -> UIViewController
  
  func buildShowListViewController_ForWatchList(coordinator: TVShowListCoordinatorProtocol,
                                                stepOrigin: TVShowListStepOrigin?) -> UIViewController
  
  func buildShowDetailCoordinator(navigationController: UINavigationController,
                                  delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinator
}

// MARK: - Steps

public enum TVShowListStep: Step {
  
  case
  
  genreList(genreId: Int, title: String?),
  
  favoriteList,
  
  watchList,
  
  showIsPicked(showId: Int,
    stepOrigin: TVShowListStepOrigin?,
    closure: (_ updated: TVShowUpdated) -> Void),
  
  showListDidFinish
}

// MARK: - ChildCoordinators

public enum TVShowListChildCoordinator {
  case detailShow
}

// MARK: - Steps Origin

public enum TVShowListStepOrigin {
  case
  
  favoriteList ,
  
  watchList
}
