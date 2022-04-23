//
//  SearchLocalStorage.swift
//  TVToday
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import Persistence
import Shared

public protocol SearchLocalStorage {
  func saveSearch(query: String, userId: Int) -> AnyPublisher<Void, CustomError>

  func fetchSearchs(userId: Int) -> AnyPublisher<[Search], CustomError>
}
