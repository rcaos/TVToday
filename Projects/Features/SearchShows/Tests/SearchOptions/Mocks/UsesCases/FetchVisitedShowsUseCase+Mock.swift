//
//  FetchVisitedShowsUseCase+Mock.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import RxSwift
@testable import Persistence

public final class FetchVisitedShowsUseCaseMock: FetchVisitedShowsUseCase {

  var error: Error?

  var result: [ShowVisited]?

  public func execute(requestValue: FetchVisitedShowsUseCaseRequestValue) -> Observable<[ShowVisited]> {
    if let error = error {
      return Observable.error(error)
    }

    if let result = result {
      return Observable.just(result)
    }

    return Observable.empty()
  }
}
