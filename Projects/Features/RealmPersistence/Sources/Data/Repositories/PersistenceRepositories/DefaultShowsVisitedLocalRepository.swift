//
//  DefaultShowsVisitedLocalRepository.swift
//  RealmPersistence
//
//  Created by Jeans Ruiz on 7/2/20.
//

import RxSwift
import Persistence

public final class DefaultShowsVisitedLocalRepository {

  private var showsVisitedLocalStorage: ShowsVisitedLocalStorage

  public init(showsVisitedLocalStorage: ShowsVisitedLocalStorage) {
    self.showsVisitedLocalStorage = showsVisitedLocalStorage
  }
}

extension DefaultShowsVisitedLocalRepository: ShowsVisitedLocalRepository {

  public func saveShow(id: Int, pathImage: String, userId: Int) -> Observable<Void> {
    return showsVisitedLocalStorage.saveShow(id: id, pathImage: pathImage, userId: userId)
  }

  public func fetchVisitedShows(userId: Int) -> Observable<[ShowVisited]> {
    return showsVisitedLocalStorage.fetchVisitedShows(userId: userId)
  }

  public func recentVisitedShowsDidChange() -> Observable<Bool> {
    return showsVisitedLocalStorage.recentVisitedShowsDidChange()
  }
}
