//
//  SearchLocalDataSource.swift
//  
//
//  Created by Jeans Ruiz on 11/05/22.
//

import Combine
import Shared

public protocol SearchLocalDataSource {
  func saveSearch(query: String, userId: Int) -> AnyPublisher<Void, ErrorEnvelope>
  func fetchRecentSearches(userId: Int) -> AnyPublisher<[SearchDLO], ErrorEnvelope>
}
