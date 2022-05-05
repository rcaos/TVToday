//
//  FetchTVShowDetails.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface
import Shared
import Persistence
import Foundation

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
  private let tvShowsVisitedRepository: ShowsVisitedLocalRepository
  private let keychainRepository: KeychainRepository

  public init(tvShowDetailsRepository: TVShowsDetailsRepository,
              keychainRepository: KeychainRepository,
              tvShowsVisitedRepository: ShowsVisitedLocalRepository) {
    self.tvShowDetailsRepository = tvShowDetailsRepository
    self.keychainRepository = keychainRepository
    self.tvShowsVisitedRepository = tvShowsVisitedRepository
  }

  public func execute(requestValue: FetchTVShowDetailsUseCaseRequestValue) -> AnyPublisher<TVShowDetail, DataTransferError> {
    var idLogged = 0
    if let userLogged = keychainRepository.fetchLoguedUser() {
      idLogged = userLogged.id
    }

    return tvShowDetailsRepository
      .fetchTVShowDetails(with: requestValue.identifier)
      .receive(on: DispatchQueue.main) // MARK: - TODO,
      .flatMap { [tvShowsVisitedRepository] details -> AnyPublisher<TVShowDetail, DataTransferError> in
        return tvShowsVisitedRepository.saveShow(id: details.id,
                                                 pathImage: details.posterPathURL?.absoluteString ?? "",
                                                 userId: idLogged)
          .map { _ -> TVShowDetail in details }
          .mapError { _ -> DataTransferError in DataTransferError.noResponse }
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}
