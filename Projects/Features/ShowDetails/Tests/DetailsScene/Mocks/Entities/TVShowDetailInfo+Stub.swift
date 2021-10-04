//
//  TVShowDetailInfo+Stub.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/4/20.
//

@testable import Shared
@testable import ShowDetails

extension TVShowDetailInfo {
  static func stub() -> Self {
    return TVShowDetailInfo(show: TVShowDetailResult.stub())
  }
}
