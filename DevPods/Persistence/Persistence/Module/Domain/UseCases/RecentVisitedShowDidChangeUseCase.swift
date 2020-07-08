//
//  RecentVisitedShowDidChangeUseCase.swift
//  Persistence
//
//  Created by Jeans Ruiz on 7/7/20.
//

import RxSwift

public protocol RecentVisitedShowDidChangeUseCase {
  
  func execute() -> Observable<Bool>
  
}

public final class DefaultRecentVisitedShowDidChangeUseCase: RecentVisitedShowDidChangeUseCase {
  
  private let showsVisitedLocalRepository: ShowsVisitedLocalRepository
  
  public init(showsVisitedLocalRepository: ShowsVisitedLocalRepository) {
    self.showsVisitedLocalRepository = showsVisitedLocalRepository
  }
  
  public func execute() -> Observable<Bool> {
    return showsVisitedLocalRepository.recentVisitedShowsDidChange()
  }
}
