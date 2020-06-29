//
//  AuthProvider.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Networking

enum AuthProvider {
  case createRequestToken
  case createSession(requestToken: String)
}

extension AuthProvider: EndPoint {
  
  var path: String {
    switch self {
    case .createRequestToken:
      return "/3/authentication/token/new"
    case .createSession:
      return "/3/authentication/session/new"
    }
  }
  
  var queryParameters: [String: Any]? {
    
    switch self {
    case .createRequestToken:
      return nil
    case .createSession(let requestToken):
      return ["request_token": "\(requestToken)"]
    }
  }
  
  var method: ServiceMethod {
    switch self {
    case .createRequestToken:
      return .get
    case .createSession:
      return .post
    }
  }
  
  var parameterEncoding: ParameterEnconding {
    switch self {
    case .createRequestToken:
      return .defaultEncoding
    case .createSession:
      return .jsonEncoding
    }
  }
}
