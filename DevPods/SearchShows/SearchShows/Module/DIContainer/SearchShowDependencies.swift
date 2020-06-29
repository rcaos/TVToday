//
//  SearchShowDependencies.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Networking

public struct SearchShowDependencies {
  
  let apiDataTransferService: DataTransferService
  let imagesBaseURL: String
  
  public init(apiDataTransferService: DataTransferService, imagesBaseURL: String) {
    self.apiDataTransferService = apiDataTransferService
    self.imagesBaseURL = imagesBaseURL
  }
}
