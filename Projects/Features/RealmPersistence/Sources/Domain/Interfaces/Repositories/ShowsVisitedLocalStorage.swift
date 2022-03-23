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

public protocol ShowsVisitedLocalStorage {
  func saveShow(id: Int, pathImage: String, userId: Int) -> AnyPublisher<Void, CustomError>

  func fetchVisitedShows(userId: Int) -> Observable<[ShowVisited]>

  func recentVisitedShowsDidChange() -> Observable<Bool>
}
