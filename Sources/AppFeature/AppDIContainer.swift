//
//  AppDIContainer.swift
//  AppFeature
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import AccountFeature
import AiringTodayFeature
import Networking
import NetworkingInterface
import Persistence
import PersistenceRealm
import PopularsFeature
import Shared
import SearchShowsFeature
import ShowDetailsFeature
import ShowDetailsFeatureInterface
import ShowListFeature
import ShowListFeatureInterface
import UIKit

public class AppDIContainer {

  private let appConfigurations: AppConfigurationProtocol

  public init(appConfigurations: AppConfigurationProtocol) {
    self.appConfigurations = appConfigurations
  }

  private lazy var apiDataTransferService: DataTransferService = {
    let queryParameters = [
      "api_key": appConfigurations.apiKey,
      "language": NSLocale.preferredLanguages.first ?? "en"
    ]

    let configuration = ApiDataNetworkConfig(
      baseURL: appConfigurations.apiBaseURL,
      headers: [
        "Content-Type": "application/json; charset=utf-8"
      ],
      queryParameters: queryParameters
    )
    let networkService = DefaultNetworkService(config: configuration)
    return DefaultDataTransferService(with: networkService)
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
  func buildAiringTodayModule() -> AiringTodayFeature.Module {
    let dependencies = AiringTodayFeature.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                             imagesBaseURL: appConfigurations.imagesBaseURL,
                                                             showDetailsBuilder: self)
    return AiringTodayFeature.Module(dependencies: dependencies)
  }

  // MARK: - Popular Module
  func buildPopularModule() -> PopularsFeature.Module {
    let dependencies = PopularsFeature.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                          imagesBaseURL: appConfigurations.imagesBaseURL,
                                                          showDetailsBuilder: self)
    return PopularsFeature.Module(dependencies: dependencies)
  }

  // MARK: - Search Module
  func buildSearchModule() -> SearchShowsFeature.Module {
    let dependencies = SearchShowsFeature.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                             imagesBaseURL: appConfigurations.imagesBaseURL,
                                                             showsPersistence: showsPersistence,
                                                             searchsPersistence: searchPersistence,
                                                             showDetailsBuilder: self,
                                                             showListBuilder: self)
    return SearchShowsFeature.Module(dependencies: dependencies)
  }

  // MARK: - Account Module
  func buildAccountModule() -> AccountFeature.Module {
    let dependencies = AccountFeature.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                         imagesBaseURL: appConfigurations.imagesBaseURL,
                                                         showListBuilder: self)
    return AccountFeature.Module(dependencies: dependencies)
  }

  // MARK: - Build TVShowDetails Module
  func buildTVShowDetailModule() -> ShowDetailsFeature.Module {
    let dependencies = ShowDetailsFeatureInterface.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                                      imagesBaseURL: appConfigurations.imagesBaseURL,
                                                                      showsPersistenceRepository: showsPersistence)
    return ShowDetailsFeature.Module(dependencies: dependencies)
  }
}

extension AppDIContainer: ModuleShowDetailsBuilder {
  public func buildModuleCoordinator(in navigationController: UINavigationController,
                                     delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinatorProtocol {
    let dependencies = ShowDetailsFeatureInterface.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                                      imagesBaseURL: appConfigurations.imagesBaseURL,
                                                                      showsPersistenceRepository: showsPersistence)
    let module =  ShowDetailsFeature.Module(dependencies: dependencies)
    return module.buildModuleCoordinator(in: navigationController, delegate: delegate)
  }
}

extension AppDIContainer: ModuleShowListDetailsBuilder {

  public func buildModuleCoordinator(in navigationController: UINavigationController,
                                     delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinatorProtocol {
    let dependencies = ShowListFeatureInterface.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                                   imagesBaseURL: appConfigurations.imagesBaseURL,
                                                                   keychainRepository: DefaultKeychainRepository(),
                                                                   showDetailsBuilder: self)
    let module = ShowListFeature.Module(dependencies: dependencies)
    return module.buildModuleCoordinator(in: navigationController, delegate: delegate)
  }
}
