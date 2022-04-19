//
//  NetworkConfigurable.swift
//  NetworkingInterface
//
//  Created by Jeans Ruiz on 19/03/22.
//

import Foundation

public protocol NetworkConfigurable {

  var baseURL: URL { get }

  /// URLRequest.allHTTPHeaderFields
  var headers: [String: String] { get }

  /// URLComponents.queryItems:
  /// 1: Global query Parameters should be Here. For All requests
  /// &api_key=XXX
  /// &language=en
  var queryParameters: [String: String] { get }
}
