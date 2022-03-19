//
//  DefaultGenresRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import NetworkingInterface

final class DefaultGenreRepository {
  private let dataTransferService: DataTransferService

  init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

// MARK: - GenresRepository
extension DefaultGenreRepository: GenresRepository {

  func genresList() -> Observable<GenreListResult> {
    let endPoint = GenreProvider.getAll
    return dataTransferService.request(endPoint, GenreListResult.self)
  }
}
