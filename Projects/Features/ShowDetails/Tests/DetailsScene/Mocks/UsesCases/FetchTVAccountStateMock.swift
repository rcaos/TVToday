//
//  FetchTVAccountStateMock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/4/20.
//

import RxSwift
@testable import ShowDetails
@testable import Shared

class FetchTVAccountStateMock: FetchTVAccountStates {

  typealias ResultForShowState = (Result<TVShowAccountStateResult, Error>)

  var error: Error?
  var result: TVShowAccountStateResult?

  func execute(requestValue: FetchTVAccountStatesRequestValue) -> Observable<ResultForShowState> {
    if let error = error {
      return Observable.just(.failure(error))
    }

    if let result = result {
      return Observable.just(.success(result))
    }

    return Observable.empty()
  }
}
