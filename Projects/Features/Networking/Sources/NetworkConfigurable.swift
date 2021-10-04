//
//  NetworkConfigurable.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/15/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public protocol NetworkConfigurable {

  var baseURL: String { get }

  /// URLRequest.allHTTPHeaderFields
  var headers: [String: String] { get }

  /// URLComponents.queryItems:
  /// 1: Global query Parameters should be Here. For All requests
  /// &api_key=XXX
  /// &language=en
  var queryParameters: [String: String] { get }
}

public struct ApiDataNetworkConfig: NetworkConfigurable {

  public let baseURL: String

  public let headers: [String: String]

  public let queryParameters: [String: String]

  public init(baseURL: String,
              headers: [String: String] = [:],
              queryParameters: [String: String] = [:]) {
    self.baseURL = baseURL
    self.headers = headers
    self.queryParameters = queryParameters
  }
}
