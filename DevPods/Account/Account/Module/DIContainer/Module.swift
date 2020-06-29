//
//  Module.swift
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

//public struct Module {
//
//  private let diContainer: DIContainer
//
//  public init(dependencies: ModuleDependencies) {
//    self.diContainer = DIContainer(dependencies: dependencies)
//  }
//
//  public func startAccountFlow() {
//
//  }
//
//}
