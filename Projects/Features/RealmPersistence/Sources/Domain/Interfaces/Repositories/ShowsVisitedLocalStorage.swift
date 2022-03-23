//
//  ShowsVisitedLocalStorage.swift
//  TVToday
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import RxSwift
import Persistence
import Shared

public protocol ShowsVisitedLocalStorage {
  func saveShow(id: Int, pathImage: String, userId: Int) -> AnyPublisher<Void, CustomError>

  func fetchVisitedShows(userId: Int) -> AnyPublisher<[ShowVisited], CustomError>

  func recentVisitedShowsDidChange() -> Observable<Bool>
}
