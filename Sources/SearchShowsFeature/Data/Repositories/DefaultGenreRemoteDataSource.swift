//
//  DefaultGenreRemoteDataSource.swift
//  
//
//  Created by Jeans Ruiz on 6/05/22.
//

import Foundation

final class DefaultGenreRemoteDataSource: GenreRemoteDataSource {

  private let dataTransferService: DataTransferService

  init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }

  func fetchGenres() -> AnyPublisher<GenreListDTO, DataTransferError> {
    let endpoint = Endpoint<GenreListDTO>(
      path: "3/genre/tv/list",
      method: .get
    )
    return dataTransferService.request(with: endpoint)
  }
}
