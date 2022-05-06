//
//  GenreRemoteDataSource.swift
//  
//
//  Created by Jeans Ruiz on 6/05/22.
//

import Foundation

public protocol GenreRemoteDataSource {
  func fetchGenres() -> AnyPublisher<GenreListDTO, DataTransferError>
}
