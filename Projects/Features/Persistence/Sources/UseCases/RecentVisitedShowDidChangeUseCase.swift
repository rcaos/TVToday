//
//  RecentVisitedShowDidChangeUseCase.swift
//  Persistence
//
//  Created by Jeans Ruiz on 7/7/20.
//

import Combine

public protocol RecentVisitedShowDidChangeUseCase {
  func execute() -> AnyPublisher<Bool, Never>
}

public final class DefaultRecentVisitedShowDidChangeUseCase: RecentVisitedShowDidChangeUseCase {
  private let showsVisitedLocalRepository: ShowsVisitedLocalRepository

  public init(showsVisitedLocalRepository: ShowsVisitedLocalRepository) {
    self.showsVisitedLocalRepository = showsVisitedLocalRepository
  }

  public func execute() -> AnyPublisher<Bool, Never> {
    return showsVisitedLocalRepository.recentVisitedShowsDidChange()
  }
}
