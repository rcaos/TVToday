//
//  DefaultSearchLocalStorage.swift
//  TVToday
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
// import RealmSwift

import Persistence

public final class DefaultSearchLocalStorage {
  
  private let realmDataStack: RealmDataStorage
  
  init(realmDataStack: RealmDataStorage) {
    self.realmDataStack = realmDataStack
  }
}

extension DefaultSearchLocalStorage: SearchLocalStorage {
  public func saveSearch(query: String, userId: Int) -> Observable<Void> {
    // Implementacion here
    return Observable.just(())
  }
  
  public func fetchSearchs() -> Observable<[Search]> {
    return Observable.just([])
  }
}
