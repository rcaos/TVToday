//
//  FetchTVShowDetails.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol FetchTVShowDetailsUseCase {
  
  func execute(requestValue: FetchTVShowDetailsUseCaseRequestValue) -> Observable<TVShowDetailResult>
}

struct FetchTVShowDetailsUseCaseRequestValue {
  let identifier: Int
}

// MARK: - FetchTVShowDetailsUseCase

final class DefaultFetchTVShowDetailsUseCase: FetchTVShowDetailsUseCase {
  
  private let tvShowDetailsRepository: TVShowDetailsRepository
  
  init(tvShowDetailsRepository: TVShowDetailsRepository) {
    self.tvShowDetailsRepository = tvShowDetailsRepository
  }
  
  func execute(requestValue: FetchTVShowDetailsUseCaseRequestValue) -> Observable<TVShowDetailResult> {
    
    return tvShowDetailsRepository.fetchTVShowDetails(with: requestValue.identifier)
  }
}
