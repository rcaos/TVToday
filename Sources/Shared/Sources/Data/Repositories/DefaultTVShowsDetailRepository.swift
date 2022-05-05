//
//  DefaultTVShowsDetailRepository.swift
//  
//
//  Created by Jeans Ruiz on 4/05/22.
//

import Foundation

public final class DefaultTVShowsDetailRepository {
  private let showsPageRemoteDataSource: TVShowsRemoteDataSource
  private let mapper: TVShowDetailsMapper
  private let imageBasePath: String

  public init(showsPageRemoteDataSource: TVShowsRemoteDataSource, mapper: TVShowDetailsMapper, imageBasePath: String) {
    self.showsPageRemoteDataSource = showsPageRemoteDataSource
    self.mapper = mapper
    self.imageBasePath = imageBasePath
  }
}

extension DefaultTVShowsDetailRepository: TVShowsDetailsRepository {
  public func fetchTVShowDetails(with showId: Int) -> AnyPublisher<TVShowDetail, DataTransferError> {
    return showsPageRemoteDataSource.fetchTVShowDetails(with: showId)
      .map { self.mapper.mapTVShow($0, imageBasePath: self.imageBasePath, imageSize: .medium) }
      .eraseToAnyPublisher()
  }
}
