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
    
    func tvShowDetails(with identifier: Int,
                       completion: @escaping (Result<TVShowDetailResult, Error>) -> Void) -> Cancellable? {
        let endPoint = TVShowsProvider.getTVShowDetail(identifier)
        
        let networkTask = dataTransferService.request(service: endPoint,
                         decodeType: TVShowDetailResult.self,
                         completion: completion)
        return RepositoryTask(networkTask: networkTask)
    }
  
  // Reactive way
  func fetchTVShowDetails(with showId: Int) -> Observable<TVShowDetailResult> {
    
    let endPoint = TVShowsProvider.getTVShowDetail(showId)
    
    return dataTransferService.request(endPoint, TVShowDetailResult.self)
  }
}
