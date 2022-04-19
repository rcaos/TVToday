//
//  DefaultGenresRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface
import Networking

final class DefaultGenreRepository {
  private let dataTransferService: DataTransferService

  init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

// MARK: - GenresRepository
extension DefaultGenreRepository: GenresRepository {

  func genresList() -> AnyPublisher<GenreListResult, DataTransferError> {
    let endpoint = Endpoint<GenreListResult>(
      path: "3/genre/tv/list",
      method: .get
    )
    return dataTransferService.request(with: endpoint)
  }
}
