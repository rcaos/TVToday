//
//  FetchTVShowDetails.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface
import RxSwift
import Shared
import Persistence

public protocol FetchTVShowDetailsUseCase {
  typealias Response = Result<TVShowDetailResult, Error>

  // MARK: - TODO Use another error maybe?
  func execute(requestValue: FetchTVShowDetailsUseCaseRequestValue) -> AnyPublisher<TVShowDetailResult, DataTransferError>
}

public struct FetchTVShowDetailsUseCaseRequestValue {
  let identifier: Int
}

// MARK: - FetchTVShowDetailsUseCase
public final class DefaultFetchTVShowDetailsUseCase: FetchTVShowDetailsUseCase {
  private let tvShowsRepository: TVShowsRepository
  private let tvShowsVisitedRepository: ShowsVisitedLocalRepository
  private let keychainRepository: KeychainRepository

  public init(tvShowsRepository: TVShowsRepository,
              keychainRepository: KeychainRepository,
              tvShowsVisitedRepository: ShowsVisitedLocalRepository) {
    self.tvShowsRepository = tvShowsRepository
    self.keychainRepository = keychainRepository
    self.tvShowsVisitedRepository = tvShowsVisitedRepository
  }

  public func execute(requestValue: FetchTVShowDetailsUseCaseRequestValue) -> AnyPublisher<TVShowDetailResult, DataTransferError> {
//    var idLogged = 0
//    if let userLogged = keychainRepository.fetchLoguedUser() {
//      idLogged = userLogged.id
//    }

    return tvShowsRepository
      .fetchTVShowDetails(with: requestValue.identifier)

//    return tvShowsRepository
//      .fetchTVShowDetails(with: requestValue.identifier)
//      .flatMap { details -> Observable<Result<TVShowDetailResult, Error>>  in
//        self.tvShowsVisitedRepository.saveShow(id: details.id ?? 0,
//                                               pathImage: details.posterPath ?? "",
//                                               userId: idLogged)
//          .flatMap { _ -> Observable<Result<TVShowDetailResult, Error>> in
//            return Observable.just(.success(details))
//        }
//    }
//    .catchErrorJustReturn(.failure(CustomError.genericError))
  }
}
