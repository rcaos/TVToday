//
//  SearchMoviesUseCase.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface

protocol FetchGenresUseCase {
  func execute(requestValue: FetchGenresUseCaseRequestValue) -> AnyPublisher<GenreList, DataTransferError>
}

struct FetchGenresUseCaseRequestValue { }

final class DefaultFetchGenresUseCase: FetchGenresUseCase {

  private let genresRepository: GenresRepository

  init(genresRepository: GenresRepository) {
    self.genresRepository = genresRepository
  }

  func execute(requestValue: FetchGenresUseCaseRequestValue) -> AnyPublisher<GenreList, DataTransferError> {
    return genresRepository.genresList()
  }
}
