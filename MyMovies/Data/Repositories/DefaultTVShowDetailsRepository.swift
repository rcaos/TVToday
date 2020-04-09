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
  
  init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

// MARK: - TVShowDetailsRepository

extension DefaultTVShowDetailsRepository: TVShowDetailsRepository {
  
  func fetchTVShowDetails(with showId: Int) -> Observable<TVShowDetailResult> {
    
    let endPoint = TVShowsProvider.getTVShowDetail(showId)
    
    return dataTransferService.request(endPoint, TVShowDetailResult.self)
  }
}
