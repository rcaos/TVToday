//
//  NetworkService.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public protocol NetworkService {
    
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable?
}

// MARK: - NetworkCancellable

public protocol NetworkCancellable {
    func cancel()
}

extension URLSessionTask: NetworkCancellable { }


// MARK: - NetworkSessionManager

public protocol NetworkSessionManager {
    
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable
}

// MARK: - NetworkErrorLogger

public protocol NetworkErrorLogger {
    
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}
