//
//  DefaultNetworkService.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public final class DefaultNetworkService {
    
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    
    public init(config: NetworkConfigurable,
                sessionManager: NetworkSessionManager = DefaultNetworkSessionManager()) {
        self.sessionManager = sessionManager
        self.config = config
    }
    
    private func request(request: URLRequest,
                         completion: @escaping CompletionHandler) -> NetworkCancellable {
        
        let sessionDataTask = sessionManager.request(request) { data, response, requestError in
            
            if let requestError = requestError {
                var error: NetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                
                completion(.failure(error))
            } else {
                completion(.success(data))
            }
        }
        return sessionDataTask
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}

extension DefaultNetworkService: NetworkService {
    
    //MARK: - Request Public Method
    
    public func request(endpoint: Requestable,
                        completion: @escaping CompletionHandler) -> NetworkCancellable? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            print("urlRequest: \(urlRequest)")
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
}
