//
//  ShowListDependencies.swift
//  TVShowsList
//
//  Created by Jeans Ruiz on 6/27/20.
//

import Foundation
import Networking
import Persistence

public struct ShowListDependencies {
  
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
