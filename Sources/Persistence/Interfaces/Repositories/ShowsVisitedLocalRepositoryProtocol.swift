//
//  ShowsVisitedLocalRepositoryProtocol.swift
//  Persistence
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import Shared

public protocol ShowsVisitedLocalRepositoryProtocol {
  func saveShow(id: Int, pathImage: String) -> AnyPublisher<Void, ErrorEnvelope>

  func fetchVisitedShows() -> AnyPublisher<[ShowVisited], ErrorEnvelope>

  func recentVisitedShowsDidChange() -> AnyPublisher<Bool, Never>
}
