//
//  ImagesProvider.swift
//  TVToday
//
//  Created by Jeans on 10/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum ImagesProvider {
    case getPoster(PosterSize, String)
    case getBackDrop(BackDropSize, String)
}

extension ImagesProvider: EndPoint {
    
    var baseURL: String {
        return "https://image.tmdb.org"
    }
    
    var path: String {
        switch self {
        case .getPoster(let size, let path):
            return "/t/p/\(size.rawValue)\(path)"
        case .getBackDrop(let size, let path):
            return "/t/p/\(size.rawValue)\(path)"
        }
    }
    
    func getParameters(with config: NetworkConfigurable) -> [String: Any] {
        return [:]
    }
    
    var parameters: [String: Any]? {
        return [:]
    }
    
    var method: ServiceMethod {
        return .get
    }
}
