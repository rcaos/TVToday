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
  
  public init(apiDataTransferService: DataTransferService,
              imagesBaseURL: String,
              showsPersistenceRepository: ShowsVisitedLocalRepository) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
    self.showsPersistenceRepository = showsPersistenceRepository
  }
}
