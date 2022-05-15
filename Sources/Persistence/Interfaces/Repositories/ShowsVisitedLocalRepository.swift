//
//  ShowsVisitedLocalRepository.swift
//  
//
//  Created by Jeans Ruiz on 11/05/22.
//

import Combine
import Shared

public final class ShowsVisitedLocalRepository {
  private let dataSource: ShowsVisitedLocalDataSource
  private let loggedUserRepository: LoggedUserRepositoryProtocol

  public init(dataSource: ShowsVisitedLocalDataSource, loggedUserRepository: LoggedUserRepositoryProtocol) {
    self.dataSource = dataSource
    self.loggedUserRepository = loggedUserRepository
  }
}

extension ShowsVisitedLocalRepository: ShowsVisitedLocalRepositoryProtocol {
  public func saveShow(id: Int, pathImage: String) -> AnyPublisher<Void, CustomError> {
    let userId = loggedUserRepository.getUser()?.id ?? 0
    return dataSource.saveShow(id: id, pathImage: pathImage, userId: userId)
  }

  public func fetchVisitedShows() -> AnyPublisher<[ShowVisited], CustomError> {
    let userId = loggedUserRepository.getUser()?.id ?? 0
    return dataSource.fetchVisitedShows(userId: userId)
      .map {
        return $0.map { ShowVisited(id: $0.id, pathImage: $0.pathImage) }
      }
      .eraseToAnyPublisher()
  }

  public func recentVisitedShowsDidChange() -> AnyPublisher<Bool, Never> {
    return dataSource.recentVisitedShowsDidChange()
  }
}
