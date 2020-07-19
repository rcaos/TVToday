//
//  TVShowDetailCoordinator.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import Networking
import Shared
import Persistence

public protocol TVShowDetailCoordinatorProtocol: class {
  
  func navigate(to step: ShowDetailsStep)
}

public protocol TVShowDetailCoordinatorDelegate: class {
  
  func tvShowDetailCoordinatorDidFinish()
}

public class TVShowDetailCoordinator: NavigationCoordinator, TVShowDetailCoordinatorProtocol {
  
  public var navigationController: UINavigationController
  
  public weak var delegate: TVShowDetailCoordinatorDelegate?
  
  private let dependencies: ShowDetailsDependencies
  
  // MARK: - Repositories
  
  private lazy var tvShowsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.imagesBaseURL)
  }()
  
  private lazy var accountShowsRepository: AccountTVShowsRepository = {
    return DefaultAccountTVShowsRepository(dataTransferService: dependencies.apiDataTransferService,
                                           basePath: dependencies.imagesBaseURL)
  }()
  
  private lazy var keychainRepository: KeychainRepository = {
    return DefaultKeychainRepository()
  }()
  
  private lazy var episodesRepository: TVEpisodesRepository = {
    return DefaultTVEpisodesRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.imagesBaseURL)
  }()
  
  // MARK: - Life Cycle
  
  public init(navigationController: UINavigationController, dependencies: ShowDetailsDependencies) {
    
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  public func start(with step: ShowDetailsStep) {
    navigate(to: step)
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: ShowDetailsStep) {
    switch step {
      
    case .showDetailsIsRequired(let showId):
      showDetailsFeature(with: showId)
      
    case .seasonsAreRequired(let showId):
      navigateToSeasonsScreen(with: showId)
      
    case .detailViewDidFinish:
      delegate?.tvShowDetailCoordinatorDidFinish()
    }
  }
  
  // MARK: - Navigate to Show Details
  
  fileprivate func showDetailsFeature(with showId: Int) {
    let viewModel = TVShowDetailViewModel(showId,
                                          fetchLoggedUser: makeFetchLoggedUserUseCase(),
                                          fetchDetailShowUseCase: makeFetchShowDetailsUseCase(),
                                          fetchTvShowState: makeTVAccountStatesUseCase(),
                                          markAsFavoriteUseCase: makeMarkAsFavoriteUseCase(),
                                          saveToWatchListUseCase: makeSaveToWatchListUseCase(),
                                          coordinator: self)
    let detailVC = TVShowDetailViewController.create(with: viewModel)
    navigationController.pushViewController(detailVC, animated: true)
  }
  
  // MARK: - Navigate Seasons List
  
  fileprivate func navigateToSeasonsScreen(with id: Int) {
    let viewModel = EpisodesListViewModel(
      tvShowId: id,
      fetchDetailShowUseCase: makeFetchShowDetailsUseCase(),
      fetchEpisodesUseCase: makeFetchEpisodesUseCase())
    let seasonsVC = EpisodesListViewController.create(with: viewModel)
    
    navigationController.pushViewController(seasonsVC, animated: true)
  }
  
  // MARK: - Uses Cases for Show Details
  
  private func makeFetchShowDetailsUseCase() -> FetchTVShowDetailsUseCase {
    return DefaultFetchTVShowDetailsUseCase(tvShowsRepository: tvShowsRepository,
                                            keychainRepository: keychainRepository,
                                            tvShowsVisitedRepository: dependencies.showsPersistenceRepository)
  }
  
  private func makeMarkAsFavoriteUseCase() -> MarkAsFavoriteUseCase {
    return DefaultMarkAsFavoriteUseCase(accountShowsRepository: accountShowsRepository,
                                        keychainRepository: keychainRepository)
  }
  
  private func makeSaveToWatchListUseCase() -> SaveToWatchListUseCase {
    return DefaultSaveToWatchListUseCase(accountShowsRepository: accountShowsRepository,
                                         keychainRepository: keychainRepository)
  }
  
  private func makeTVAccountStatesUseCase() -> FetchTVAccountStates {
    return DefaultFetchTVAccountStates(accountShowsRepository: accountShowsRepository,
                                       keychainRepository: keychainRepository)
  }
  
  private func makeFetchLoggedUserUseCase() -> FetchLoggedUser {
    return DefaultFetchLoggedUser(keychainRepository: keychainRepository)
  }
  
  // MARK: - Uses Cases for Seasons
  
  private func makeFetchEpisodesUseCase() -> FetchEpisodesUseCase {
    return DefaultFetchEpisodesUseCase(episodesRepository: episodesRepository)
  }
  
}

// MARK: - Steps

public enum ShowDetailsStep: Step {
  
  case
  
  showDetailsIsRequired(withId: Int),
  
  seasonsAreRequired(withId: Int),
  
  detailViewDidFinish
}
