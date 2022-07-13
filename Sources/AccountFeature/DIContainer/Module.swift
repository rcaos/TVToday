//
//  AccountDependencies.swift
//  Account
//
//  Created by Jeans Ruiz on 6/26/20.
//

import Foundation
import UIKit
import NetworkingInterface
import Persistence
import Shared
import ShowListFeatureInterface

public struct ModuleDependencies {

  let apiDataTransferService: DataTransferService
  let imagesBaseURL: String
  let authenticateBaseURL: String
  let showListBuilder: ModuleShowListDetailsBuilder
  let requestTokenRepository: RequestTokenRepositoryProtocol
  let accessTokenRepository: AccessTokenRepositoryProtocol
  let userLoggedRepository: LoggedUserRepositoryProtocol

  public init(apiDataTransferService: DataTransferService,
              imagesBaseURL: String,
              authenticateBaseURL: String,
              requestTokenRepository: RequestTokenRepositoryProtocol,
              accessTokenRepository: AccessTokenRepositoryProtocol,
              userLoggedRepository: LoggedUserRepositoryProtocol,
              showListBuilder: ModuleShowListDetailsBuilder
  ) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
    self.authenticateBaseURL = authenticateBaseURL
    self.showListBuilder = showListBuilder
    self.requestTokenRepository = requestTokenRepository
    self.accessTokenRepository = accessTokenRepository
    self.userLoggedRepository = userLoggedRepository
  }
}

// MARK: - Entry to Module
public struct Module {

  private let diContainer: DIContainer

  public init(dependencies: ModuleDependencies) {
    self.diContainer = DIContainer(dependencies: dependencies)
  }

  public func buildAccountCoordinator(in navigationController: UINavigationController) -> Coordinator {
    return diContainer.buildModuleCoordinator(navigationController: navigationController)
  }
}
