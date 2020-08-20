//
//  SearchCoordinatorProtocol.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 8/12/20.
//

import ShowDetails
import TVShowsList
import Shared

protocol SearchCoordinatorProtocol: class {
  
  func navigate(to step: SearchStep)
}

// MARK: - Coordinator Dependencies

protocol SearchCoordinatorDependencies {
  
  func buildSearchViewController(coordinator: SearchCoordinatorProtocol?) -> UIViewController
  
  func buildTVShowListCoordinator(navigationController: UINavigationController) -> TVShowListCoordinator
  
  func buildTVShowDetailCoordinator(navigationController: UINavigationController,
                                    delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinator
}

// MARK: - Steps

public enum SearchStep: Step {
  
  case
  
  searchFeatureInit,
  
  genreIsPicked(withId: Int, title: String?),
  
  showIsPicked(withId: Int)
}

// MARK: - ChildCoordinators

public enum SearchChildCoordinator {
  case
  
  detailShow,
  
  genreList
}
