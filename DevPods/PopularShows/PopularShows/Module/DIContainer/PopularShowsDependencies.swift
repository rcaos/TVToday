//
//  PopularShowsDependencies.swift
//  PopularShows
//
//  Created by Jeans Ruiz on 6/28/20.
//

import Foundation
import Networking

public struct PopularShowsDependencies {
  
  let apiDataTransferService: DataTransferService
  let imagesBaseURL: String
  
  public init(apiDataTransferService: DataTransferService, imagesBaseURL: String) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
  }
}
