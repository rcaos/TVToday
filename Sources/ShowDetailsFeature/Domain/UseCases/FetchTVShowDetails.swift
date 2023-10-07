//
//  FetchTVShowDetails.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import Foundation
import NetworkingInterface
import Persistence
import Shared
import UI

public protocol FetchTVShowDetailsUseCase {
  // MARK: - TODO Use another error maybe?
  func execute(requestValue: FetchTVShowDetailsUseCaseRequestValue) -> AnyPublisher<TVShowDetail, DataTransferError>
}

public struct FetchTVShowDetailsUseCaseRequestValue {
  let identifier: Int
}

// MARK: - FetchTVShowDetailsUseCase
public final class DefaultFetchTVShowDetailsUseCase: FetchTVShowDetailsUseCase {
  private let tvShowDetailsRepository: TVShowsDetailsRepository
  private let tvShowsVisitedRepository: ShowsVisitedLocalRepositoryProtocol // MARK: - TODO, Move this logic to TVShowsDetailsRepository

  public init(tvShowDetailsRepository: TVShowsDetailsRepository,
              tvShowsVisitedRepository: ShowsVisitedLocalRepositoryProtocol) {
    self.tvShowDetailsRepository = tvShowDetailsRepository
    self.tvShowsVisitedRepository = tvShowsVisitedRepository
  }

  public func execute(requestValue: FetchTVShowDetailsUseCaseRequestValue) -> AnyPublisher<TVShowDetail, DataTransferError> {
    return tvShowDetailsRepository
      .fetchTVShowDetails(with: requestValue.identifier)
      .receive(on: defaultScheduler)
      .flatMap { [tvShowsVisitedRepository] details -> AnyPublisher<TVShowDetail, DataTransferError> in
        return tvShowsVisitedRepository.saveShow(id: details.id,
                                                 pathImage: details.posterPathURL?.absoluteString ?? "")
          .map { _ -> TVShowDetail in details }
          .mapError { _ -> DataTransferError in DataTransferError.noResponse }
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}
