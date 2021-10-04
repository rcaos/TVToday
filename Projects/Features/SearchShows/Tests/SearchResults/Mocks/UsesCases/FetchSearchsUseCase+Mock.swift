//
//  FetchSearchsUseCase+Mock.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import RxSwift
@testable import SearchShows
@testable import Shared
@testable import Persistence

final class FetchSearchsUseCaseMock: FetchSearchsUseCase {
  var error: Error?
  var result: [Search]?

  public func execute(requestValue: FetchSearchsUseCaseRequestValue) -> Observable<[Search]> {
    if let error = error {
      return Observable.error(error)
    }

    if let result = result {
      return Observable.just(result)
    }

    return Observable.empty()
  }
}
