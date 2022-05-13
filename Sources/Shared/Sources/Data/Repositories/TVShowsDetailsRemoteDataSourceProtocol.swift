//
//  TVShowsDetailsRemoteDataSourceProtocol.swift
//  
//
//  Created by Jeans Ruiz on 13/05/22.
//

import Foundation

public protocol TVShowsDetailsRemoteDataSourceProtocol {
  func fetchTVShowDetails(with showId: Int) -> AnyPublisher<TVShowDetailDTO, DataTransferError>
}
