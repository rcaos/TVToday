//
//  Created by Jeans Ruiz on 1/16/20.
//

import Combine
import NetworkingInterface
import Networking
import Shared

final class DefaultGenreRepository: GenresRepository {
  private let remoteDataSource: GenreRemoteDataSource

  init(remoteDataSource: GenreRemoteDataSource) {
    self.remoteDataSource = remoteDataSource
  }

  func genresList() async throws -> GenreList {
    let dto = try await remoteDataSource.fetchGenres()
    let genres = dto.genres.map { Genre(id: $0.id, name: $0.name) }
    return GenreList(genres: genres)
  }
}
