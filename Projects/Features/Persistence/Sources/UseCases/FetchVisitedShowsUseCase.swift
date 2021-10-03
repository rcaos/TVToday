//
//  FetchVisitedShowsUseCase.swift
//  Persistence
//
//  Created by Jeans Ruiz on 7/3/20.
//

import RxSwift
import Shared

public protocol FetchVisitedShowsUseCase {
  func execute(requestValue: FetchVisitedShowsUseCaseRequestValue) -> Observable<[ShowVisited]>
}

public struct FetchVisitedShowsUseCaseRequestValue {
  public init() { }
}

public final class DefaultFetchVisitedShowsUseCase: FetchVisitedShowsUseCase {

  private let showsVisitedLocalRepository: ShowsVisitedLocalRepository
  private let keychainRepository: KeychainRepository

  public init(showsVisitedLocalRepository: ShowsVisitedLocalRepository,
              keychainRepository: KeychainRepository) {
    self.showsVisitedLocalRepository = showsVisitedLocalRepository
    self.keychainRepository = keychainRepository
  }

  public func execute(requestValue: FetchVisitedShowsUseCaseRequestValue) -> Observable<[ShowVisited]> {

    var idLogged = 0
    if let userLogged = keychainRepository.fetchLoguedUser() {
      idLogged = userLogged.id
    }

    return showsVisitedLocalRepository.fetchVisitedShows(userId: idLogged)
  }
}
