//
//  DefaultTVShowDetailsRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultTVShowDetailsRepository {
  
  private let dataTransferService: DataTransferService
  
  private let basePath: String?
  
  init(dataTransferService: DataTransferService, basePath: String? = nil) {
    self.dataTransferService = dataTransferService
    self.basePath = basePath
  }
}

// MARK: - TVShowDetailsRepository

extension DefaultTVShowDetailsRepository: TVShowDetailsRepository {
  
  func fetchTVShowDetails(with showId: Int) -> Observable<TVShowDetailResult> {
    
    let endPoint = TVShowsProvider.getTVShowDetail(showId)
    
    return dataTransferService.request(endPoint, TVShowDetailResult.self)
      .flatMap { response -> Observable<TVShowDetailResult> in
        Observable.just( self.mapShowDetailsWithBasePath(response: response))
      }
  }
  
  fileprivate func mapShowDetailsWithBasePath(response: TVShowDetailResult) -> TVShowDetailResult {
    guard let basePath = basePath else { return response }
    
    var newResponse = response
    newResponse.backDropPath = basePath + "/t/p/w780" + ( response.backDropPath ?? "" )
    newResponse.posterPath = basePath + "/t/p/w780" + ( response.posterPath ?? "" )
    return newResponse
  }
}
