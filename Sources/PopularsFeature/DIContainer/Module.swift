//
//  PopularShowsDependencies.swift
//  PopularShows
//
//  Created by Jeans Ruiz on 6/28/20.
//

import Foundation
import UIKit
import NetworkingInterface
import Shared
import ShowDetailsInterface

public struct ModuleDependencies {

  let apiDataTransferService: DataTransferService
  let imagesBaseURL: String
  let showDetailsBuilder: ModuleShowDetailsBuilder

  public init(apiDataTransferService: DataTransferService,
              imagesBaseURL: String,
              showDetailsBuilder: ModuleShowDetailsBuilder) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
    self.showDetailsBuilder = showDetailsBuilder
  }
}

// MARK: - Entry to Module
public struct Module {

  private let diContainer: DIContainer

  public init(dependencies: ModuleDependencies) {
    self.diContainer = DIContainer(dependencies: dependencies)
  }

  public func buildPopularCoordinator(in navigationController: UINavigationController) -> Coordinator {
    return diContainer.buildPopularCoordinator(navigationController: navigationController)
  }
}
