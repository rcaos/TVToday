//
//  Created by Jeans Ruiz on 4/7/20.
//

import Foundation
import UIKit
import NetworkingInterface
import Persistence
import Shared
import ShowDetailsFeatureInterface
import ShowListFeatureInterface

public struct ModuleDependencies {
  let apiClient: ApiClient
  let imagesBaseURL: String
  let showsPersistence: ShowsVisitedLocalRepositoryProtocol
  let searchsPersistence: SearchLocalRepositoryProtocol

  let showDetailsBuilder: ModuleShowDetailsBuilder
  let showListBuilder: ModuleShowListDetailsBuilder

  public init(
    apiClient: ApiClient,
    imagesBaseURL: String,
    showsPersistence: ShowsVisitedLocalRepositoryProtocol,
    searchsPersistence: SearchLocalRepositoryProtocol,
    showDetailsBuilder: ModuleShowDetailsBuilder,
    showListBuilder: ModuleShowListDetailsBuilder
  ) {

    self.apiClient = apiClient
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
