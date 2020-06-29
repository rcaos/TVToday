//
//  SearchFlow.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxFlow
import Networking
import ShowDetails
import TVShowsList
import Shared

public class SearchFlow: Flow {
  
  private let dependencies: SearchShowDependencies
  
  public var root: Presentable {
    return self.rootViewController
  }
  
  private lazy var rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    return navigationController
  }()
  
  // MARK: - Repositories
  
  private lazy var showsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(
      dataTransferService: dependencies.apiDataTransferService,
      basePath: dependencies.imagesBaseURL)
  }()
  
  private lazy var genresRepository: GenresRepository = {
    return DefaultGenreRepository(dataTransferService: dependencies.apiDataTransferService)
  }()
  
  // MARK: - Dependencies
  private lazy var showListDependencies: ShowListDependencies = {
    return ShowListDependencies(apiDataTransferService: dependencies.apiDataTransferService,
                                imagesBaseURL: dependencies.imagesBaseURL)
  }()
  
  private lazy var showDetailsDependencies: ShowDetailsDependencies = {
    return ShowDetailsDependencies(apiDataTransferService: dependencies.apiDataTransferService,
                                   imagesBaseURL: dependencies.imagesBaseURL)
  }()
  
  // MARK: - Life Cycle
  
  public init(dependencies: SearchShowDependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: Step) -> FlowContributors {
    switch step {
    case SearchStep.searchFeatureInit:
      return navigateToSearchFeature()
      
    case SearchStep.genreIsPicked(let id):
      return navigateToGenreListScreen(with: id)
      
    case SearchStep.showIsPicked(let showId):
      return navigateToShowDetailScreen(with: showId)
      
    default:
      return .none
    }
  }
  
    fileprivate func navigateToSearchFeature() -> FlowContributors {
      let viewModel = SearchViewModel(
        fetchGenresUseCase: makeFetchGenresUseCase(),
        fetchTVShowsUseCase: makeSearchShowsUseCase())
      let searchVC = SearchViewController.create(with: viewModel)
  
      rootViewController.pushViewController(searchVC, animated: true)
  
      return .one(flowContributor: .contribute(
        withNextPresentable: searchVC, withNextStepper: viewModel))
    }
  
  fileprivate func navigateToGenreListScreen(with id: Int) -> FlowContributors {
    let listFlow = TVShowsListFlow(rootViewController: rootViewController,
                                   dependencies: showListDependencies)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: listFlow,
      withNextStepper:
      OneStepper(withSingleStep: TVShowListStep.genreList(genreId: id) )))
  }
  
  // MARK: - Navigate to Detail TVShow
  
  fileprivate func navigateToShowDetailScreen(with id: Int) -> FlowContributors {
    let detailShowFlow = TVShowDetailFlow(rootViewController: rootViewController,
                                          dependencies: showDetailsDependencies)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: detailShowFlow,
      withNextStepper:
      OneStepper(withSingleStep:
        ShowDetailsStep.showDetailsIsRequired(withId: id))))
  }
  
  // MARK: - Uses Cases
  
  private func makeFetchGenresUseCase() -> FetchGenresUseCase {
    return DefaultFetchGenresUseCase(genresRepository: genresRepository)
  }
  
  private func makeSearchShowsUseCase() -> SearchTVShowsUseCase {
    return DefaultSearchTVShowsUseCase(tvShowsRepository: showsRepository)
  }
}

// MARK: - Steps

public enum SearchStep: Step {
  
  case
  
  searchFeatureInit,
  
  genreIsPicked(withId: Int),
  
  showIsPicked(withId: Int)
}
