//
//  ShowsVisitedLocalDataSource.swift
//  
//
//  Created by Jeans Ruiz on 11/05/22.
//

import Combine
import Shared

public protocol ShowsVisitedLocalDataSource {
  func saveShow(id: Int, pathImage: String, userId: Int) -> AnyPublisher<Void, ErrorEnvelope>

  func fetchVisitedShows(userId: Int) -> AnyPublisher<[ShowVisitedDLO], ErrorEnvelope>

  func recentVisitedShowsDidChange() -> AnyPublisher<Bool, Never>
}
