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
            return "/t/p/\(size.rawValue)/\(path)"
        case .getBackDrop(let size, let path):
            return "/t/p/\(size.rawValue)/\(path)"
        }
    }
    
    var parameters: [String: Any]? {
        //var params: [String: Any] = [:]
        //return params
        return [:]
    }
    
    var method: ServiceMethod {
        return .get
    }
}

enum PosterSize: String{
    //w92, w154, w185, w300, w500, original
    case smallPoster = "w92"
    case mediumPoster = "w342"
    case bigPoster = "w500"
}

enum BackDropSize: String{
    //w300, w780, w1280, original
    case smallBackDrop = "w300"
    case mediumBackDrop = "w780"
    case bigBackDrop = "w1280"
}
