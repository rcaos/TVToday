//
//  TVShowListCoordinator.swift
//  TVShowsList
//
//  Created by Jeans Ruiz on 6/27/20.
//

import UIKit
import Shared
import ShowDetailsInterface

public class TVShowListCoordinator: NavigationCoordinator, TVShowListCoordinatorProtocol {
  
  public var navigationController: UINavigationController
  
  public weak var delegate: TVShowListCoordinatorDelegate?
  
  private let dependencies: TVShowListCoordinatorDependencies
  
  private var childCoordinators = [TVShowListChildCoordinator: Coordinator]()
  
  // MARK: - Life Cycle
  init(navigationController: UINavigationController,
       dependencies: TVShowListCoordinatorDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  public func start(with step: TVShowListStep) {
    navigate(to: step)
  }
  
  // MARK: - Navigation
  public func navigate(to step: TVShowListStep) {
    switch step {
    case .genreList(let genreId, let title):
      navigateToGenreList(with: genreId, title: title)
      
    case .watchList:
      navigateToWatchList()
      
    case .favoriteList:
      navigateToFavorites()
      
    case .showIsPicked(let showId, let stepOrigin, let closure):
      navigateToShowDetailScreen(with: showId, stepOrigin: stepOrigin, closure: closure)
      
    case .showListDidFinish:
      delegate?.tvShowListCoordinatorDidFinish()
    }
  }
  
  // MARK: - Navigate to Genre List
  fileprivate func navigateToGenreList(with genreId: Int, title: String?) {
    let viewController = dependencies.buildShowListViewController_ForGenres(with: genreId, coordinator: self, stepOrigin: nil)
    viewController.title = title
    navigationController.pushViewController(viewController, animated: true)
  }
  
  // MARK: - Navigate to Favorites User
  
  fileprivate func navigateToFavorites() {
    let viewController = dependencies.buildShowListViewController_ForFavorites(coordinator: self, stepOrigin: .favoriteList)
    viewController.title = "Favorites"
    navigationController.pushViewController(viewController, animated: true)
  }
  
  // MARK: - Navigate to WatchList User
  
  fileprivate func navigateToWatchList() {
    let viewController = dependencies.buildShowListViewController_ForWatchList(coordinator: self, stepOrigin: .watchList)
    viewController.title = "Watch List"
    navigationController.pushViewController(viewController, animated: true)
  }
  
  // MARK: - Navigate to Detail TVShow
  fileprivate func navigateToShowDetailScreen(with id: Int,
                                              stepOrigin: TVShowListStepOrigin?,
                                              closure: ((_ updated: TVShowUpdated) -> Void)? ) {
    let tvDetailCoordinator = dependencies.buildTVShowDetailCoordinator(navigationController: navigationController, delegate: self)
    childCoordinators[.detailShow] = tvDetailCoordinator

    let closures = makeClosures(with: stepOrigin, closure: closure)
    let detailStep = ShowDetailsStep.showDetailsIsRequired(withId: id, closures: closures)
    tvDetailCoordinator.navigate(to: detailStep)
  }
  
  fileprivate func makeClosures(with stepOrigin: TVShowListStepOrigin?,
                                closure: ((_ updated: TVShowUpdated) -> Void)? ) -> TVShowDetailViewModelClosures? {
    switch stepOrigin {
    case .favoriteList:
      return TVShowDetailViewModelClosures(updateFavoritesShows: closure)
    case .watchList:
      return TVShowDetailViewModelClosures(updateWatchListShows: closure)
    default:
      return nil
    }
  }
}

// MARK: - TVShowDetailCoordinatorDelegate
extension TVShowListCoordinator: TVShowDetailCoordinatorDelegate {

  public func tvShowDetailCoordinatorDidFinish() {
    childCoordinators[.detailShow] = nil
  }
}
