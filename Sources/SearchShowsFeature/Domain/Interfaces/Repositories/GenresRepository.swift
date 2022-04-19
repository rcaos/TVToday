//
//  GenresRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface

protocol GenresRepository {
  func genresList() -> AnyPublisher<GenreListResult, DataTransferError>
}
