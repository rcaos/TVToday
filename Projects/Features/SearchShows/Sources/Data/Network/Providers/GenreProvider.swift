//
//  GenreProvider.swift
//  TVToday
//
//  Created by Jeans on 10/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import NetworkingInterface

enum GenreProvider {
  case getAll
}

extension GenreProvider: EndPoint {
  var path: String {
    switch self {
    case .getAll:
      return "/3/genre/tv/list"
    }
  }

  var queryParameters: [String: Any]? {
    return nil
  }

  var method: ServiceMethod {
    return .get
  }

  var parameterEncoding: ParameterEnconding {
    return .defaultEncoding
  }
}
