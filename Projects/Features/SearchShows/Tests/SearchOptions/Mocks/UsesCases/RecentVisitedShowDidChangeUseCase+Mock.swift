//
//  RecentVisitedShowDidChangeUseCase+Mock.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import RxSwift
@testable import Persistence

final class RecentVisitedShowDidChangeUseCaseMock: RecentVisitedShowDidChangeUseCase {

  var error: Error?
  var result: Bool?

  func execute() -> Observable<Bool> {
    if let error = error {
      return Observable.error(error)
    }

    if let result = result {
      return Observable.just(result)
    }

    return Observable.empty()
  }
}
