//
//  TVShowsDetailsRemoteDataSource.swift
//  
//
//  Created by Jeans Ruiz on 13/05/22.
//

import Combine
import Networking
import NetworkingInterface

public final class TVShowsDetailsRemoteDataSource: TVShowsDetailsRemoteDataSourceProtocol {
  private let dataTransferService: DataTransferService

  public init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }

  public func fetchTVShowDetails(with showId: Int) -> AnyPublisher<TVShowDetailDTO, DataTransferError> {
    let endpoint = Endpoint<TVShowDetailDTO>(
      path: "3/tv/\(showId)",
      method: .get
    )
    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }
}
