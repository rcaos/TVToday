//
//  ShowDetailsDependencies.swift
//  ShowDetails
//
//  Created by Jeans Ruiz on 6/28/20.
//

import Foundation
import Networking
import Persistence

public struct ShowDetailsDependencies {
  
  let apiDataTransferService: DataTransferService
  let imagesBaseURL: String
  let showsPersistenceRepository: ShowsVisitedLocalRepository
  public var tvShowId: Int?
  
  public init(apiDataTransferService: DataTransferService,
              imagesBaseURL: String,
              showsPersistenceRepository: ShowsVisitedLocalRepository,
              tvShowId: Int? = nil) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
    self.showsPersistenceRepository = showsPersistenceRepository
    self.tvShowId = tvShowId
  }
}
