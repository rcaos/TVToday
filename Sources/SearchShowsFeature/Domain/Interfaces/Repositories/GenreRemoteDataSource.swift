//
//  GenreRemoteDataSource.swift
//  
//
//  Created by Jeans Ruiz on 6/05/22.
//

import Combine
import NetworkingInterface

public protocol GenreRemoteDataSource {
  func fetchGenres() -> AnyPublisher<GenreListDTO, DataTransferError>
}
