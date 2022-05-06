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
import Shared

final class DefaultGenreRepository {
  private let remoteDataSource: GenreRemoteDataSource

  init(remoteDataSource: GenreRemoteDataSource) {
    self.remoteDataSource = remoteDataSource
  }
}

extension DefaultGenreRepository: GenresRepository {

  func genresList() -> AnyPublisher<GenreList, DataTransferError> {
    return remoteDataSource.fetchGenres()
      .map { list in
        let genresDomain = list.genres.map { Genre(id: $0.id, name: $0.name) }
        return GenreList(genres: genresDomain )
      }
      .eraseToAnyPublisher()
  }
}
