//
//  AccountDependencies.swift
//  Account
//
//  Created by Jeans Ruiz on 6/26/20.
//

import Foundation
import Networking

public struct AccountDependencies {
  
  let apiDataTransferService: DataTransferService
  let imagesBaseURL: String
  
  public init(apiDataTransferService: DataTransferService, imagesBaseURL: String) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
  }
}
