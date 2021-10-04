//
//  DefaultSearchLocalStorage.swift
//  TVToday
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import RealmSwift
import Persistence

public final class DefaultSearchLocalStorage {
  private let store: PersistenceStore<RealmSearchShow>

  public init(realmDataStack: RealmDataStorage) {
    self.store = PersistenceStore(realmDataStack.realm)
  }
}

extension DefaultSearchLocalStorage: SearchLocalStorage {

  public func saveSearch(query: String, userId: Int) -> Observable<Void> {
    return Observable<()>.create { [weak self] (event) -> Disposable in
      let disposable = Disposables.create()

      let persistEntitie = RealmSearchShow()
      persistEntitie.query = query
      persistEntitie.userId = userId

      self?.store.saveSearch(entitie: persistEntitie) {
        event.onNext(())
        event.onCompleted()
      }
      return disposable
    }
  }

  public func fetchSearchs(userId: Int) -> Observable<[Search]> {
    return Observable.just(
      store.find(for: userId).map { $0.asDomain() })
  }
}
