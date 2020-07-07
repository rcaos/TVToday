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
  
  private let realmDataStack: RealmDataStorage
  
  private let searchsSubject = BehaviorSubject<[Search]>(value: [])
  
  public init(realmDataStack: RealmDataStorage) {
    self.realmDataStack = realmDataStack
    self.realmDataStack.delegateSearchs = self
  }
}

extension DefaultSearchLocalStorage: SearchLocalStorage {
  
  public func saveSearch(query: String, userId: Int) -> Observable<Void> {
    return Observable<()>.create { [weak self] (event) -> Disposable in
      let disposable = Disposables.create()
      
      let persistEntitie = RealmSearchShow()
      persistEntitie.query = query
      persistEntitie.userId = userId
      
      self?.realmDataStack.saveQuery(entitie: persistEntitie) {
        event.onNext(())
        event.onCompleted()
      }
      return disposable
    }
  }
  
  // MARK: - TODO, filter with userId
  
  public func fetchSearchs(userId: Int) -> Observable<[Search]> {
    searchsSubject.onNext( fetchSearchsList() )
    return searchsSubject.asObservable()
  }
  
  fileprivate func fetchSearchsList() -> [Search] {
    return realmDataStack.fetchAllSearchs().map { $0.asDomain() }
  }
}

extension DefaultSearchLocalStorage: RealmDataStorageSearchsDelegate {
  
  func persistenceStore(didUpdateEntity update: Bool) {
    searchsSubject.onNext( fetchSearchsList() )
  }
}
