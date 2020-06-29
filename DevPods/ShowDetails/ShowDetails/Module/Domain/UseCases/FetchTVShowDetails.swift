//
//  FetchTVShowDetails.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import Shared

public protocol FetchTVShowDetailsUseCase {
  
  func execute(requestValue: FetchTVShowDetailsUseCaseRequestValue) -> Observable<TVShowDetailResult>
}

public struct FetchTVShowDetailsUseCaseRequestValue {
  let identifier: Int
}

// MARK: - FetchTVShowDetailsUseCase

public final class DefaultFetchTVShowDetailsUseCase: FetchTVShowDetailsUseCase {
  
  private let tvShowsRepository: TVShowsRepository
  
  public init(tvShowsRepository: TVShowsRepository) {
    self.tvShowsRepository = tvShowsRepository
  }
  
  public func execute(requestValue: FetchTVShowDetailsUseCaseRequestValue) -> Observable<TVShowDetailResult> {
    return tvShowsRepository.fetchTVShowDetails(with: requestValue.identifier)
  }
}
