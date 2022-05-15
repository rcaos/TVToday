//
//  ShowVisited.swift
//  TVToday
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public struct ShowVisited: Hashable {
  public let id: Int
  public let pathImage: String  // MARK: - TODO, consider this could contain the URL already

  public init(id: Int, pathImage: String) {
    self.id = id
    self.pathImage = pathImage
  }
}
