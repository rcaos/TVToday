//
//  MarkAsFavoriteUseCaseMock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/4/20.
//

import RxSwift
@testable import ShowDetails
@testable import Shared

class MarkAsFavoriteUseCaseMock: MarkAsFavoriteUseCase {
  typealias Response = Result<Bool, Error>

  var error: Error?
  var result: Bool?

  func execute(requestValue: MarkAsFavoriteUseCaseRequestValue) -> Observable<Response> {
    if let error = error {
      return Observable.just(.failure(error))
    }

    if let result = result {
      return Observable.just(.success(result))
    }

    return Observable.empty()
  }
}
