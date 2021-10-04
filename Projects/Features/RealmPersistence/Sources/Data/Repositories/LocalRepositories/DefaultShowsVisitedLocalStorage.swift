//
//  DefaultShowsVisitedLocalStorage.swift
//  TVToday
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import RealmSwift
import Persistence

public final class DefaultShowsVisitedLocalStorage {

  private let store: PersistenceStore<RealmShowVisited>

  private let recentsShowsSubject = BehaviorSubject<Bool>(value: true)

  public init(realmDataStack: RealmDataStorage) {
    self.store = PersistenceStore(realmDataStack.realm)
    self.store.subscribeToChanges()
    self.store.delegate = self
  }
}

extension DefaultShowsVisitedLocalStorage: ShowsVisitedLocalStorage {

  public func saveShow(id: Int, pathImage: String, userId: Int) -> Observable<Void> {

    return Observable<()>.create { [weak self] (event) -> Disposable in
      let disposable = Disposables.create()

      let persistEntitie = RealmShowVisited()
      persistEntitie.id = id
      persistEntitie.userId = userId
      persistEntitie.pathImage = pathImage

      self?.store.saveVisit(entitie: persistEntitie) {
        event.onNext(())
        event.onCompleted()
      }

      return disposable
    }
  }

  public func fetchVisitedShows(userId: Int) -> Observable<[ShowVisited]> {
    return Observable.just(
      store.find(for: userId).map { $0.asDomain() }
    )
  }

  public func recentVisitedShowsDidChange() -> Observable<Bool> {
    return recentsShowsSubject.asObservable()
  }
}

// MARK: - RealmDataStorageDelegate
extension DefaultShowsVisitedLocalStorage: PersistenceStoreDelegate {
  func persistenceStore(didUpdateEntity update: Bool) {
    recentsShowsSubject.onNext(update)
  }
}
