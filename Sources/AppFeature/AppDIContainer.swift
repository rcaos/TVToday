//
//  Created by Jeans Ruiz on 4/7/20.
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
import UI

public class AppDIContainer {

  private let appConfigurations: AppConfigurationProtocol

  public init(appConfigurations: AppConfigurationProtocol) {
    self.appConfigurations = appConfigurations

    language = Language(languageStrings: Locale.preferredLanguages) ?? .en
    Strings.currentLocale = Locale(identifier: language.rawValue)
  }

  private let language: Language

  private lazy var apiClient: ApiClient = {
    let queryParameters = [
      "api_key": appConfigurations.apiKey,
      "language": language.rawValue
    ]
    let config = NetworkConfig(
      baseURL: appConfigurations.apiBaseURL,
      headers: [
        "Content-Type": "application/json; charset=utf-8"
      ],
      queryParameters: queryParameters
    )
    return ApiClient.live(networkConfig: config)
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
    let dependencies = AiringTodayFeature.ModuleDependencies(
      apiClient: apiClient,
      imagesBaseURL: appConfigurations.imagesBaseURL,
      showDetailsBuilder: self
    )
    return AiringTodayFeature.Module(dependencies: dependencies)
  }

  // MARK: - Popular Module
  func buildPopularModule() -> PopularsFeature.Module {
    let dependencies = PopularsFeature.ModuleDependencies(
      apiClient: apiClient,
      imagesBaseURL: appConfigurations.imagesBaseURL,
      showDetailsBuilder: self
    )
    return PopularsFeature.Module(dependencies: dependencies)
  }

  // MARK: - Search Module
  func buildSearchModule() -> SearchShowsFeature.Module {
    let dependencies = SearchShowsFeature.ModuleDependencies(
      apiClient: apiClient,
      imagesBaseURL: appConfigurations.imagesBaseURL,
      showsPersistence: showsPersistence,
      searchsPersistence: searchPersistence,
      showDetailsBuilder: self,
      showListBuilder: self
    )
    return SearchShowsFeature.Module(dependencies: dependencies)
  }

  // MARK: - Account Module
  func buildAccountModule() -> AccountFeature.Module {
    let dependencies = AccountFeature.ModuleDependencies(
      apiClient: apiClient,
      imagesBaseURL: appConfigurations.imagesBaseURL,
      authenticateBaseURL: appConfigurations.authenticateBaseURL,
      gravatarBaseURL: appConfigurations.gravatarBaseURL,
      requestTokenRepository: requestTokenRepository,
      accessTokenRepository: accessTokenRepository,
      userLoggedRepository: loggedUserRepository,showListBuilder: self
    )
    return AccountFeature.Module(dependencies: dependencies)
  }
}

extension AppDIContainer: ModuleShowDetailsBuilder {
  public func buildModuleCoordinator(in navigationController: UINavigationController,
                                     delegate: TVShowDetailCoordinatorDelegate?) -> TVShowDetailCoordinatorProtocol {
    let dependencies = ShowDetailsFeatureInterface.ModuleDependencies(
      apiClient: apiClient,
      imagesBaseURL: appConfigurations.imagesBaseURL,
      showsPersistenceRepository: showsPersistence,
      loggedUserRepository: loggedUserRepository
    )
    let module =  ShowDetailsFeature.Module(dependencies: dependencies)
    return module.buildModuleCoordinator(in: navigationController, delegate: delegate)
  }
}

extension AppDIContainer: ModuleShowListDetailsBuilder {

  public func buildModuleCoordinator(in navigationController: UINavigationController,
                                     delegate: TVShowListCoordinatorDelegate?) -> TVShowListCoordinatorProtocol {
    let dependencies = ShowListFeatureInterface.ModuleDependencies(
      apiClient: apiClient,
      imagesBaseURL: appConfigurations.imagesBaseURL,
      loggedUserRepository: loggedUserRepository,
      showDetailsBuilder: self
    )
    let module = ShowListFeature.Module(dependencies: dependencies)
    return module.buildModuleCoordinator(in: navigationController, delegate: delegate)
  }
}
