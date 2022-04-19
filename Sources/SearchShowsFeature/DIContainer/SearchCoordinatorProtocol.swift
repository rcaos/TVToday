//
//  SearchCoordinatorProtocol.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 8/12/20.
//

import UIKit
import ShowDetailsFeatureInterface
import ShowListFeatureInterface
import Shared

protocol SearchCoordinatorProtocol: AnyObject {
  func navigate(to step: SearchStep)
}

// MARK: - Coordinator Dependencies
protocol SearchCoordinatorDependencies {
  func buildSearchViewController(coordinator: SearchCoordinatorProtocol?) -> UIViewController

  func buildTVShowDetailCoordinator(navigationController: UINavigationController,
                                    delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinatorProtocol

  func buildTVShowListCoordinator(navigationController: UINavigationController,
                                  delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinatorProtocol
}

// MARK: - Steps
public enum SearchStep: Step {
  case searchFeatureInit
  case genreIsPicked(withId: Int, title: String?)
  case showIsPicked(withId: Int)
}

// MARK: - ChildCoordinators

public enum SearchChildCoordinator {
  case detailShow
  case genreList
}
