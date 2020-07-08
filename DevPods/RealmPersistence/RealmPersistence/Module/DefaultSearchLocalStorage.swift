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
  
  public init(realmDataStack: RealmDataStorage) {
    self.realmDataStack = realmDataStack
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
  
  public func fetchSearchs(userId: Int) -> Observable<[Search]> {
    return Observable.just(
      realmDataStack.fetchAllSearchs(for: userId).map { $0.asDomain() })
  }
}
