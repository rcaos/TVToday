//
//  ApiError.swift
//  TVToday
//
//  Created by Jeans on 10/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum APIError: Error {
  
  case networkProblem
  case requestFailed
  case invalidData
  case unknown(HTTPURLResponse?)
  
  case badRequest
  case notAuthenticaded
  case notFound
  
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
}

extension APIError: LocalizedError {
  
  public var errorDescription: String? {
    switch self {
    case .notAuthenticaded:
      return ErrorMessages.NotAuthorized
    case .notFound:
      return ErrorMessages.NotFound
    case .networkProblem, .unknown:
      return ErrorMessages.ServerError
    case .requestFailed, .badRequest, .invalidData:
      return ErrorMessages.RequestFailed
    }
  }
  
}

extension APIError {
  
  struct ErrorMessages {
    static let ServerError = "Server Error, Please, try again later."
    static let NotAuthorized = "This information is not available."
    static let NotFound = "Bad requested error."
    static let RequestFailed = "Request failed. Please try again later."
  }
}
