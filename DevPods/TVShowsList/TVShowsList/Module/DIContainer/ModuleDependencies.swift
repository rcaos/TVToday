//
//  ModuleDependencies.swift
//  TVShowsList
//
//  Created by Jeans Ruiz on 6/27/20.
//

import Foundation
import Networking

public struct ShowListDependencies {
  
  let apiDataTransferService: DataTransferService
  let imagesBaseURL: String
  
  public init(apiDataTransferService: DataTransferService, imagesBaseURL: String) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
  }
}
