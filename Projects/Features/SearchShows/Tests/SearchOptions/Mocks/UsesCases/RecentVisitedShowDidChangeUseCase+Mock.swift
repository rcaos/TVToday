//
//  RecentVisitedShowDidChangeUseCase+Mock.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import Combine
import Persistence

final class RecentVisitedShowDidChangeUseCaseMock: RecentVisitedShowDidChangeUseCase {
  var result: Bool?

  func execute() -> AnyPublisher<Bool, Never> {
    if let result = result {
      return Just(result).eraseToAnyPublisher()
    }

    return Empty().eraseToAnyPublisher()
  }
}
