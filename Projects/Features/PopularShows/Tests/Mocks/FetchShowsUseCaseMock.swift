//
//  FetchShowsUseCaseMock.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

import RxSwift
import RxTest

@testable import Shared

class FetchShowsUseCaseMock: FetchTVShowsUseCase {

  var error: Error?
  var result: TVShowResult?

  func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> Observable<TVShowResult> {
    if let error = error {
      return Observable.error(error)
    }

    if let result = result {
      return Observable.just(result)
    }

    return Observable.empty()
  }
}
