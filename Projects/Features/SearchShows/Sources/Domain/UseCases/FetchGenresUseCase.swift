//
//  SearchMoviesUseCase.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol FetchGenresUseCase {
  func execute(requestValue: FetchGenresUseCaseRequestValue) -> Observable<GenreListResult>
}

struct FetchGenresUseCaseRequestValue {
}

final class DefaultFetchGenresUseCase: FetchGenresUseCase {

  private let genresRepository: GenresRepository

  init(genresRepository: GenresRepository) {
    self.genresRepository = genresRepository
  }

  func execute(requestValue: FetchGenresUseCaseRequestValue) -> Observable<GenreListResult> {
    return genresRepository.genresList()
  }
}
