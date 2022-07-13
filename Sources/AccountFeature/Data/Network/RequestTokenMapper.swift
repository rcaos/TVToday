//
//  RequestTokenMapper.swift
//  
//
//  Created by Jeans Ruiz on 13/07/22.
//

import Foundation
import NetworkingInterface

protocol RequestTokenMapperProtocol {
  func mapRequestToken(model: NewRequestTokenDTO) throws -> NewRequestToken
}

struct RequestTokenMapper: RequestTokenMapperProtocol {
  private let authenticateBaseURL: String

  init(authenticateBaseURL: String) {
    self.authenticateBaseURL = authenticateBaseURL
  }
  
  func mapRequestToken(model: NewRequestTokenDTO) throws -> NewRequestToken {
    if model.success == true,
       let url = URL(string: "\(authenticateBaseURL)/\(model.token)") {
      return NewRequestToken(token: model.token, url: url)
    } else {
      print("cannot Convert request token= \(model), basePath=\(authenticateBaseURL)")
      throw DataTransferError.noResponse // MARk: - TODO, change error
    }
  }
}
