//
//  ShowVisited.swift
//  TVToday
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public struct ShowVisited {
  
  let id: Int
  
  let pathImage: String
  
  public init(id: Int, pathImage: String) {
    self.id = id
    self.pathImage = pathImage
  }
}
