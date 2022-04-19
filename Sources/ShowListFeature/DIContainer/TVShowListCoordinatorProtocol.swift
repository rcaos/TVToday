//
//  TVShowListCoordinatorProtocol.swift
//  TVShowsList
//
//  Created by Jeans Ruiz on 8/12/20.
//

import UIKit
import ShowDetailsFeatureInterface
import ShowListFeatureInterface

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

// MARK: - ChildCoordinators
public enum TVShowListChildCoordinator {
  case detailShow
}
