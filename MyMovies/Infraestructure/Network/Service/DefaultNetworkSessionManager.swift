//
//  DefaultNetworkSessionManager.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

// Note: If authorization is needed NetworkSessionManager can be implemented by using,
// for example, Alamofire SessionManager with its RequestAdapter and RequestRetrier.
// And it can be incjected into NetworkService instead of default one.

public class DefaultNetworkSessionManager: NetworkSessionManager {
    
    public init() {}
    
    public func request(_ request: URLRequest,
                        completion: @escaping CompletionHandler) -> NetworkCancellable {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        
        task.resume()
        return task
    }
}
