//
//  DefaultAccountTVShowDetailsMapper.swift
//  
//
//  Created by Jeans Ruiz on 5/05/22.
//

import Foundation

public final class DefaultAccountTVShowDetailsMapper: AccountTVShowsDetailsMapperProtocol {

  public init() { }

  public func mapActionResult(result: TVShowActionStatusDTO) -> TVShowActionStatus {
    return TVShowActionStatus(statusCode: result.code, statusMessage: result.message ?? "")
  }

  public func mapTVShowStatusResult(result: TVShowAccountStatusDTO) -> TVShowAccountStatus {
    return TVShowAccountStatus(showId: result.showId, isFavorite: result.isFavorite, isWatchList: result.isWatchList)
  }
}
