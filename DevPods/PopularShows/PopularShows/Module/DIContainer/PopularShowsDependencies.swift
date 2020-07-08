//
//  PopularShowsDependencies.swift
//  PopularShows
//
//  Created by Jeans Ruiz on 6/28/20.
//

import Foundation
import Networking
import Persistence

public struct PopularShowsDependencies {
  
  let apiDataTransferService: DataTransferService
  let imagesBaseURL: String
  let showsPersistence: ShowsVisitedLocalRepository
  
  public init(apiDataTransferService: DataTransferService,
              imagesBaseURL: String,
              showsPersistence: ShowsVisitedLocalRepository) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
    self.showsPersistence = showsPersistence
  }
}
