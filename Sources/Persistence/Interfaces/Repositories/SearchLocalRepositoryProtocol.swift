//
//  SearchLocalRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import Shared

public protocol SearchLocalRepositoryProtocol {
  func saveSearch(query: String) -> AnyPublisher<Void, CustomError>
  func fetchRecentSearches() -> AnyPublisher<[Search], CustomError>
}
