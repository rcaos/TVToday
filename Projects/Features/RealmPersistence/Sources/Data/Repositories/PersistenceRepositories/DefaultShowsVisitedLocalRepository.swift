//
//  DefaultShowsVisitedLocalRepository.swift
//  RealmPersistence
//
//  Created by Jeans Ruiz on 7/2/20.
//

import Combine
import Persistence
import Shared

public final class DefaultShowsVisitedLocalRepository {

  private var showsVisitedLocalStorage: ShowsVisitedLocalStorage

  public init(showsVisitedLocalStorage: ShowsVisitedLocalStorage) {
    self.showsVisitedLocalStorage = showsVisitedLocalStorage
  }
}

extension DefaultShowsVisitedLocalRepository: ShowsVisitedLocalRepository {

  public func saveShow(id: Int, pathImage: String, userId: Int) -> AnyPublisher<Void, CustomError> {
    return showsVisitedLocalStorage.saveShow(id: id, pathImage: pathImage, userId: userId)
  }

  public func fetchVisitedShows(userId: Int) -> AnyPublisher<[ShowVisited], CustomError> {
    return showsVisitedLocalStorage.fetchVisitedShows(userId: userId)
  }

  public func recentVisitedShowsDidChange() -> AnyPublisher<Bool, Never> {
    return showsVisitedLocalStorage.recentVisitedShowsDidChange()
  }
}
