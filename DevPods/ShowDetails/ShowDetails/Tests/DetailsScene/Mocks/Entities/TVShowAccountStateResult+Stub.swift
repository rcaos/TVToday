//
//  TVShowAccountStateResult+Stub.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/4/20.
//

@testable import Shared

extension TVShowAccountStateResult {
  
  static func stub(id: Int = 1,
                   isFavorite: Bool = true,
                   isWatchList: Bool = true) -> Self {
    
    TVShowAccountStateResult(id: id,
                             isFavorite: isFavorite,
                             isWatchList: isWatchList)
  }
}
