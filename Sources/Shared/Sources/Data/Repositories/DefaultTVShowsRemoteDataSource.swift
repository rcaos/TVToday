//
//  DefaultTVShowsRemoteDataSource.swift
//  
//
//  Created by Jeans Ruiz on 30/04/22.
//

import Combine
import Networking
import NetworkingInterface

public final class DefaultTVShowsRemoteDataSource: TVShowsRemoteDataSource {
  private let dataTransferService: DataTransferService

  public init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }

  public func fetchAiringTodayShows(page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError> {
    let endpoint = Endpoint<TVShowPageDTO>(
      path: "3/tv/airing_today",
      method: .get,
      queryParameters: ["page": page]
    )
    return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
  }
}
