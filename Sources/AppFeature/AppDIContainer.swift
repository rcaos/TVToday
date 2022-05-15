//
//  AppDIContainer.swift
//  AppFeature
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import AccountFeature
import AiringTodayFeature
import KeyChainStorage
import Networking
import NetworkingInterface
import Persistence
import PersistenceLive
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

  private lazy var localStorage: LocalStorage = {
    return LocalStorage(coreDataStorage: .shared)
  }()

  lazy var showsPersistence: ShowsVisitedLocalRepositoryProtocol = {
    return ShowsVisitedLocalRepository(dataSource: localStorage.getShowVisitedDataSource(limitStorage: 10),
                                       loggedUserRepository: loggedUserRepository)
  }()

  lazy var searchPersistence: SearchLocalRepository = {
    return SearchLocalRepository(dataSource: localStorage.getRecentSearchesDataSource(),
                                 loggedUserRepository: loggedUserRepository)
  }()

  lazy var loggedUserRepository: LoggedUserRepositoryProtocol = {
    return LoggedUserRepository(dataSource: keyChainStorage)
  }()

  lazy var requestTokenRepository: RequestTokenRepositoryProtocol = {
    return RequestTokenRepository(dataSource: keyChainStorage)
  }()

  lazy var accessTokenRepository: AccessTokenRepositoryProtocol = {
    return AccessTokenRepository(dataSource: keyChainStorage)
  }()

  private lazy var keyChainStorage = DefaultKeyChainStorage()

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
                                                         requestTokenRepository: requestTokenRepository,
                                                         accessTokenRepository: accessTokenRepository,
                                                         userLoggedRepository: loggedUserRepository,showListBuilder: self)
    return AccountFeature.Module(dependencies: dependencies)
  }

  // MARK: - Build TVShowDetails Module
//  func buildTVShowDetailModule() -> ShowDetailsFeature.Module {
//    let dependencies = ShowDetailsFeatureInterface.ModuleDependencies(apiDataTransferService: apiDataTransferService,
//                                                                      imagesBaseURL: appConfigurations.imagesBaseURL,
//                                                                      showsPersistenceRepository: showsPersistence)
//    return ShowDetailsFeature.Module(dependencies: dependencies)
//  }
}

extension AppDIContainer: ModuleShowDetailsBuilder {
  public func buildModuleCoordinator(in navigationController: UINavigationController,
                                     delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinatorProtocol {
    let dependencies = ShowDetailsFeatureInterface.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                                      imagesBaseURL: appConfigurations.imagesBaseURL,
                                                                      showsPersistenceRepository: showsPersistence,
                                                                      loggedUserRepository: loggedUserRepository)
    let module =  ShowDetailsFeature.Module(dependencies: dependencies)
    return module.buildModuleCoordinator(in: navigationController, delegate: delegate)
  }
}

extension AppDIContainer: ModuleShowListDetailsBuilder {

  public func buildModuleCoordinator(in navigationController: UINavigationController,
                                     delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinatorProtocol {
    let dependencies = ShowListFeatureInterface.ModuleDependencies(apiDataTransferService: apiDataTransferService,
                                                                   imagesBaseURL: appConfigurations.imagesBaseURL,
                                                                   loggedUserRepository: loggedUserRepository,
                                                                   showDetailsBuilder: self)
    let module = ShowListFeature.Module(dependencies: dependencies)
    return module.buildModuleCoordinator(in: navigationController, delegate: delegate)
  }
}
