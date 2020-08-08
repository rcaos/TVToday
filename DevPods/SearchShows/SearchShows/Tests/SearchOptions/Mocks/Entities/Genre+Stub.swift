//
//  TVShowResult+Stub.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

@testable import Shared

extension Genre {
  
  static func stub(id: Int = 1,
                   name: String = "") -> Self {
    Genre(id: id, name: name)
  }
}
