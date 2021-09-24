//
//  DefaultSearchLocalRepository.swift
//  RealmPersistence
//
//  Created by Jeans Ruiz on 7/3/20.
//

import RxSwift
import Persistence

public final class DefaultSearchLocalRepository {
  
  private var searchLocalStorage: SearchLocalStorage
  
  public init(searchLocalStorage: SearchLocalStorage) {
    self.searchLocalStorage = searchLocalStorage
  }
}

extension DefaultSearchLocalRepository: SearchLocalRepository {
  
  public func saveSearch(query: String, userId: Int) -> Observable<Void> {
    return searchLocalStorage.saveSearch(query: query, userId: userId)
  }
  
  public func fetchSearchs(userId: Int) -> Observable<[Search]> {
    return searchLocalStorage.fetchSearchs(userId: userId)
  }
}
