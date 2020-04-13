//
//  ApiError.swift
//  TVToday
//
//  Created by Jeans on 10/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum APIError: Error {
  
  case requestFailed
  case invalidData
  
  case badRequest         //400
  case notAuthenticaded   //401
  case notFound           //404
  
  case unknown(HTTPURLResponse?)
  
  init(response: URLResponse?) {
    guard let response = response as? HTTPURLResponse else {
      self = .unknown(nil)
      return
    }
    switch response.statusCode {
    case 400:
      self = .badRequest
    case 401:
      self = .notAuthenticaded
    case 404:
      self = .notFound
    default:
      self = .unknown(response)
    }
  }
  
  var description: String {
    switch self {
    case .notAuthenticaded:
      return "This information is not available."
    case .notFound:
      return "Bad request error."
    case .unknown:
      return "Server Error. Please, try again later."
    case .requestFailed, .invalidData, .badRequest:
      return "Resquest failed. Please, try again later."
    }
  }
}
