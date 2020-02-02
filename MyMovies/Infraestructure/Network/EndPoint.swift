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
    
    func getParameters(with config: NetworkConfigurable) -> [String: Any]
}

extension EndPoint {
    
    func getUrlRequest(with config: NetworkConfigurable) -> URLRequest {
        guard let url = getUrl(with: config) else {
            fatalError("URL could not be built")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
    
    private func getUrl(with config: NetworkConfigurable) -> URL? {
        var urlComponents = URLComponents(string: config.baseURL)
        urlComponents?.path = path
        
        var queryItems:[URLQueryItem] = []
        
        let params = getParameters(with: config)
        if method == .get && params.count > 0 {
            queryItems.append(contentsOf: params.map({
                return URLQueryItem(name: "\($0)", value: "\($1)")
            }))
        }
        
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
}

public enum ServiceMethod: String {
    case get = "GET"
    // implement more when needed: post, put, delete, patch, etc.
}
