//
//  DefaultSearchLocalRepository.swift
//  RealmPersistence
//
//  Created by Jeans Ruiz on 7/3/20.
//

import Combine
import Persistence
import Shared

public final class DefaultSearchLocalRepository {
  private var searchLocalStorage: SearchLocalStorage

  public init(searchLocalStorage: SearchLocalStorage) {
    self.searchLocalStorage = searchLocalStorage
  }
}

extension DefaultSearchLocalRepository: SearchLocalRepository {

  public func saveSearch(query: String, userId: Int) -> AnyPublisher<Void, CustomError> {
    return searchLocalStorage.saveSearch(query: query, userId: userId)
  }

  public func fetchSearchs(userId: Int) -> AnyPublisher<[Search], CustomError> {
    return searchLocalStorage.fetchSearchs(userId: userId)
  }
}
