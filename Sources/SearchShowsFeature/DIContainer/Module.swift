//
//  SearchShowDependencies.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import UIKit
import NetworkingInterface
import Persistence
import Shared
import ShowDetailsFeatureInterface
import ShowListFeatureInterface

public struct ModuleDependencies {

  let apiDataTransferService: DataTransferService
  let imagesBaseURL: String
  let showsPersistence: ShowsVisitedLocalRepositoryProtocol
  let searchsPersistence: SearchLocalRepository

  let showDetailsBuilder: ModuleShowDetailsBuilder
  let showListBuilder: ModuleShowListDetailsBuilder

  public init(apiDataTransferService: DataTransferService,
              imagesBaseURL: String,
              showsPersistence: ShowsVisitedLocalRepositoryProtocol,
              searchsPersistence: SearchLocalRepository,
              showDetailsBuilder: ModuleShowDetailsBuilder,
              showListBuilder: ModuleShowListDetailsBuilder) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
    self.showsPersistence = showsPersistence
    self.searchsPersistence = searchsPersistence
    self.showDetailsBuilder = showDetailsBuilder
    self.showListBuilder = showListBuilder
  }
}

// MARK: - Entry to Module
public struct Module {
  private let diContainer: DIContainer

  public init(dependencies: ModuleDependencies) {
    self.diContainer = DIContainer(dependencies: dependencies)
  }

  public func buildSearchCoordinator(in navigationController: UINavigationController) -> Coordinator {
    return diContainer.buildModuleCoordinator(navigationController: navigationController)
  }
}
