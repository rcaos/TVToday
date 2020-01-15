//
//  NetworkError.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

// MARK: - NetworkError

extension NetworkError {
    
    public var isNotFoundError: Bool { return hasStatusCode(404) }
    
    public func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case let .error(code, _):
            return code == codeError
        default: return false
        }
    }
}
