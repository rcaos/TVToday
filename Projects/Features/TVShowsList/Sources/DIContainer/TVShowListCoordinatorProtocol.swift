//
//  TVShowListCoordinatorProtocol.swift
//  TVShowsList
//
//  Created by Jeans Ruiz on 8/12/20.
//

import UIKit
import Shared
import ShowDetailsInterface

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

    func buildTVShowDetailCoordinator(navigationController: UINavigationController,
                                    delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinatorProtocol
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

// MARK: - ChildCoordinators
public enum TVShowListChildCoordinator {
  case detailShow
}

// MARK: - Steps Origin
public enum TVShowListStepOrigin {
  case favoriteList
  case watchList
}
