//
//  SearchCoordinator.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import UI
import Shared
import ShowDetailsFeatureInterface
import ShowListFeatureInterface

class SearchCoordinator: NavigationCoordinator, SearchCoordinatorProtocol {

  let navigationController: UINavigationController

  private let dependencies: SearchCoordinatorDependencies

  private var childCoordinators = [SearchChildCoordinator: Coordinator]()

  // MARK: - Life Cycle
  public init(navigationController: UINavigationController, dependencies: SearchCoordinatorDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }

  public func start() {
    navigate(to: .searchFeatureInit)
  }

  // MARK: - Navigation
  public func navigate(to step: SearchStep) {
    switch step {
    case .searchFeatureInit:
      navigateToSearchFeature()

    case .genreIsPicked(let id, let title):
      navigateToGenreListScreen(with: id, title: title)

    case .showIsPicked(let showId):
      navigateToShowDetailScreen(with: showId)
    }
  }

  // MARK: - Main Search Screen
  fileprivate func navigateToSearchFeature() {
    let searchVC = dependencies.buildSearchViewController(coordinator: self)
    searchVC.navigationItem.title = Strings.searchTitle.localized()
    navigationController.pushViewController(searchVC, animated: true)
  }

  // MARK: - Navigate to List by Genre
  fileprivate func navigateToGenreListScreen(with id: Int, title: String?) {
    let listCoordinator = dependencies.buildTVShowListCoordinator(navigationController: navigationController, delegate: self)
    childCoordinators[.genreList] = listCoordinator
    let nextStep = TVShowListStep.genreList(genreId: id, title: title)
    listCoordinator.navigate(to: nextStep)
  }

  // MARK: - Navigate to Detail TVShow
  fileprivate func navigateToShowDetailScreen(with showId: Int) {
    let coordinator = dependencies.buildTVShowDetailCoordinator(navigationController: navigationController, delegate: self)
    childCoordinators[.detailShow] = coordinator
    let nextStep = ShowDetailsStep.showDetailsIsRequired(withId: showId)
    coordinator.navigate(to: nextStep)
  }
}

// MARK: - TVShowListCoordinatorDelegate
extension SearchCoordinator: TVShowListCoordinatorDelegate {
  public func tvShowListCoordinatorDidFinish() {
    childCoordinators[.genreList] = nil
  }
}

// MARK: - TVShowDetailCoordinatorDelegate
extension SearchCoordinator: TVShowDetailCoordinatorDelegate {
  public func tvShowDetailCoordinatorDidFinish() {
    childCoordinators[.detailShow] = nil
  }
}
