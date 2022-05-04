//
//  DefaultTVShowsPageRepository.swift
//  
//
//  Created by Jeans Ruiz on 30/04/22.
//

import NetworkingInterface
import Combine

public final class DefaultTVShowsPageRepository {
  private let showsPageRemoteDataSource: TVShowsRemoteDataSource
  private let mapper: TVShowPageMapper
  private let imageBasePath: String

  public init(showsPageRemoteDataSource: TVShowsRemoteDataSource, mapper: TVShowPageMapper, imageBasePath: String) {
    self.showsPageRemoteDataSource = showsPageRemoteDataSource
    self.mapper = mapper
    self.imageBasePath = imageBasePath
  }
}

extension DefaultTVShowsPageRepository: TVShowsPageRepository {

  public func fetchAiringTodayShows(page: Int) -> AnyPublisher<TVShowPage, DataTransferError> {
    return showsPageRemoteDataSource.fetchAiringTodayShows(page: page)
      .map { self.mapper.mapTVShowPage($0, imageBasePath: self.imageBasePath, imageSize: .medium) }
      .eraseToAnyPublisher()
  }

  public func fetchPopularShows(page: Int) -> AnyPublisher<TVShowPage, DataTransferError> {
    return showsPageRemoteDataSource.fetchPopularShows(page: page)
      .map { self.mapper.mapTVShowPage($0, imageBasePath: self.imageBasePath, imageSize: .medium) }
      .eraseToAnyPublisher()
  }

  public func fetchShowsByGenre(genreId: Int, page: Int) -> AnyPublisher<TVShowPage, DataTransferError> {
    return showsPageRemoteDataSource.fetchShowsByGenre(genreId: genreId, page: page)
      .map { self.mapper.mapTVShowPage($0, imageBasePath: self.imageBasePath, imageSize: .medium) }
      .eraseToAnyPublisher()
  }
}
