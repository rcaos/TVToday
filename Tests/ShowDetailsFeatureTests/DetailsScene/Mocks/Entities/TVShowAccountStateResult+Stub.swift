//
//  TVShowAccountStateResult+Stub.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/4/20.
//

@testable import Shared

extension TVShowAccountStatus {
  static func stub(showId: Int = 1,
                   isFavorite: Bool = true,
                   isWatchList: Bool = true) -> Self {
    TVShowAccountStatus(
      showId: showId,
      isFavorite: isFavorite,
      isWatchList: isWatchList)
  }
}
