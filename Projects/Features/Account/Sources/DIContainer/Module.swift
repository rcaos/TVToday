//
//  AccountDependencies.swift
//  Account
//
//  Created by Jeans Ruiz on 6/26/20.
//

import Foundation
import UIKit
import Networking
import Persistence
import Shared
import TVShowsListInterface

public struct ModuleDependencies {

  let apiDataTransferService: DataTransferService
  let imagesBaseURL: String
  let showListBuilder: ModuleShowListDetailsBuilder

  public init(apiDataTransferService: DataTransferService,
              imagesBaseURL: String,
              showListBuilder: ModuleShowListDetailsBuilder) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
    self.showListBuilder = showListBuilder
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
