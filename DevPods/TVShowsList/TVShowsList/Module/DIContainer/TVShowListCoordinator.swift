//
//  TVShowListCoordinator.swift
//  TVShowsList
//
//  Created by Jeans Ruiz on 6/27/20.
//

import Networking
import Shared
import ShowDetails

public protocol TVShowListCoordinatorProtocol: class {
  
  func navigate(to step: TVShowListStep)
}

public protocol TVShowListCoordinatorDelegate: class {
  
  func tvShowListCoordinatorDidFinish()
}

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

// MARK: - Default Implementation

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
    let tvDetailCoordinator = dependencies.buildShowDetailCoordinator(navigationController: navigationController, delegate: self)
    childCoordinators[.detailShow] = tvDetailCoordinator
    
    let closures = makeClosures(with: stepOrigin, closure: closure)
    let detailStep = ShowDetailsStep.showDetailsIsRequired(withId: id, closures: closures)
    tvDetailCoordinator.start(with: detailStep)
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
