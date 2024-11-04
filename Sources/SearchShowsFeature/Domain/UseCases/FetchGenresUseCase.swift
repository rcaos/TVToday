//
//  Created by Jeans on 1/14/20.
//

import NetworkingInterface

protocol FetchGenresUseCase {
  func execute() async throws -> GenreList
}

final class DefaultFetchGenresUseCase: FetchGenresUseCase {

  private let genresRepository: GenresRepository

  init(genresRepository: GenresRepository) {
    self.genresRepository = genresRepository
  }

  //DataTransferError
  func execute() async throws -> GenreList {
    return try await genresRepository.genresList()
  }
}
