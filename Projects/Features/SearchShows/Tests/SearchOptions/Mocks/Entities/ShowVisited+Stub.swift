//
//  ShowVisited+Stub.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

@testable import Persistence

extension ShowVisited {
  static func stub(id: Int = 1,
                   pathImage: String = "") -> Self {
    ShowVisited(id: id, pathImage: pathImage)
  }
}
