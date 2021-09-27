//
//  AppDIContainer.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import UIKit

import Networking
import Persistence
import RealmPersistence
import Shared

import AiringToday
import PopularShows
import SearchShows
import Account
import ShowDetails
import ShowDetailsInterface
import TVShowsList
import TVShowsListInterface

public class AppDIContainer {
  
  lazy var appConfigurations = AppConfigurations()
  
  lazy var apiDataTransferService: DataTransferService = {
    let queryParameters = [
      "api_key": appConfigurations.apiKey,
      "language": NSLocale.preferredLanguages.first ?? "en"]
    
    let configuration = ApiDataNetworkConfig(
      baseURL: appConfigurations.apiBaseURL,
      queryParameters: queryParameters)
    
    return ApiClient(with: configuration)
  }()
  
  lazy var realmDataStorage: RealmDataStorage = {
    return RealmDataStorage()
  }()
  
  lazy var showsPersistence: ShowsVisitedLocalRepository = {
    let localStorage = DefaultShowsVisitedLocalStorage(realmDataStack: realmDataStorage)
    return DefaultShowsVisitedLocalRepository(showsVisitedLocalStorage: localStorage)
  }()
  
  lazy var searchPersistence: SearchLocalRepository = {
    let localStorage = DefaultSearchLocalStorage(realmDataStack: realmDataStorage)
    return DefaultSearchLocalRepository(searchLocalStorage: localStorage)
  }()
  
  // MARK: - Airing Today Module
  func buildAiringTodayModule() -> AiringToday.Module {
    let dependencies = AiringToday.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                      imagesBaseURL: appConfigurations.imagesBaseURL,
                                                      showDetailsBuilder: self)
    return AiringToday.Module(dependencies: dependencies)
  }
  
  // MARK: - Popular Module
  func buildPopularModule() -> PopularShows.Module {
    let dependencies = PopularShows.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                       imagesBaseURL: appConfigurations.imagesBaseURL,
                                                       showDetailsBuilder: self)
    return PopularShows.Module(dependencies: dependencies)
  }
  
  // MARK: - Search Module
  func buildSearchModule() -> SearchShows.Module {
    let dependencies = SearchShows.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                      imagesBaseURL: appConfigurations.imagesBaseURL,
                                                      showsPersistence: showsPersistence,
                                                      searchsPersistence: searchPersistence,
                                                      showDetailsBuilder: self,
                                                      showListBuilder: self)
    return SearchShows.Module(dependencies: dependencies)
  }
  
  // MARK: - Account Module
  func buildAccountModule() -> Account.Module {
    let dependencies = Account.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                  imagesBaseURL: appConfigurations.imagesBaseURL,
                                                  showsPersistence: showsPersistence,
                                                  showListBuilder: self)
    return Account.Module(dependencies: dependencies)
  }

  // MARK: - Build TVShowDetails Module
  func buildTVShowDetailModule() -> ShowDetails.Module {
    let dependencies = ShowDetailsInterface.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                               imagesBaseURL: appConfigurations.imagesBaseURL,
                                                               showsPersistenceRepository: showsPersistence)
    return ShowDetails.Module(dependencies: dependencies)
  }
}

extension AppDIContainer: ModuleShowDetailsBuilder {
  public func buildModuleCoordinator(in navigationController: UINavigationController, delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinatorProtocol {
    let dependencies = ShowDetailsInterface.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                               imagesBaseURL: appConfigurations.imagesBaseURL,
                                                               showsPersistenceRepository: showsPersistence)
    let module =  ShowDetails.Module(dependencies: dependencies)
    return module.buildModuleCoordinator(in: navigationController, delegate: delegate)
  }
}

extension AppDIContainer: ModuleShowListDetailsBuilder {

  public func buildModuleCoordinator(in navigationController: UINavigationController,
                                     delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinatorProtocol {
    let dependencies = TVShowsListInterface.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                               imagesBaseURL: appConfigurations.imagesBaseURL,
                                                               showDetailsBuilder: self)
    let module = TVShowsList.Module(dependencies: dependencies)
    return module.buildModuleCoordinator(in: navigationController, delegate: delegate)
  }
}
