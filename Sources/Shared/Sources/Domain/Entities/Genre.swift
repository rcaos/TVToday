//
//  Genre.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

public struct Genre: Hashable {
  
  public init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
  
  public let id: Int
  public let name: String
}
