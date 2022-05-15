//
//  ShowVisitedDLO.swift
//  
//
//  Created by Jeans Ruiz on 11/05/22.
//

import Foundation

public struct ShowVisitedDLO: Hashable {
  public let id: Int
  public let pathImage: String

  public init(id: Int, pathImage: String) {
    self.id = id
    self.pathImage = pathImage
  }
}
