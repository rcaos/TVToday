//
//  EndPoint.swift
//  TVToday
//
//  Created by Jeans on 10/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

public protocol EndPoint {
  
  var path: String { get }
  
  var method: ServiceMethod { get }
  
  var queryParameters: [String: Any]? { get }
}

extension EndPoint {
  
  func getUrlRequest(with config: NetworkConfigurable) -> URLRequest {
    guard let url = getUrl(with: config) else {
      fatalError("URL could not be built")
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    
    guard let params = queryParameters, method != .get else { return request }
    
    return buildRequest(request, with: params)
  }
  
  private func buildRequest(_ request: URLRequest, with params: [String: Any]) -> URLRequest {
    var postRequest = request
    postRequest.setJSONContentType()
    let jsonData = try? JSONSerialization.data(withJSONObject: params)
    postRequest.httpBody = jsonData
    return postRequest
  }
  
  private func getUrl(with config: NetworkConfigurable) -> URL? {
    var urlComponents = URLComponents(string: config.baseURL)
    urlComponents?.path = path
    
    var queryItems: [URLQueryItem] = []
    
    if method == .get {
      // Global query parameters
      queryItems.append(contentsOf:
        mapToQueryItems(parameters: config.queryParameters))
      
      // Specifically for each Request
      queryItems.append(contentsOf:
        mapToQueryItems(parameters: queryParameters))
    }
    
    urlComponents?.queryItems = queryItems
    return urlComponents?.url
  }
  
  private func mapToQueryItems(parameters: [String: Any]?) -> [URLQueryItem] {
    guard let parameters = parameters else { return [] }
    
    return parameters.map { return URLQueryItem(name: "\($0)", value: "\($1)") }
  }
}

public enum ServiceMethod: String {
  case get = "GET"
  case post = "POST"
  
  // implement more when needed: post, put, delete, patch, etc.
}
