//
//  Created by Jeans Ruiz on 30/04/22.
//

import NetworkingInterface
import Combine

public final class DefaultTVShowsPageRepository {
  private let showsPageRemoteDataSource: TVShowsRemoteDataSourceProtocol
  private let mapper: TVShowPageMapperProtocol
  private let imageBasePath: String

  public init(showsPageRemoteDataSource: TVShowsRemoteDataSourceProtocol, mapper: TVShowPageMapperProtocol, imageBasePath: String) {
    self.showsPageRemoteDataSource = showsPageRemoteDataSource
    self.mapper = mapper
    self.imageBasePath = imageBasePath
  }
}

extension DefaultTVShowsPageRepository: TVShowsPageRepository {
  public func fetchAiringTodayShows(page: Int) async -> TVShowPage? {
    do {
      let dto = try await showsPageRemoteDataSource.fetchAiringTodayShows(page: page)
      let domain = mapper.mapTVShowPage(dto, imageBasePath: imageBasePath, imageSize: .medium)
      return domain
    } catch {
      #warning("todo: log error, check error strategies")
      return nil
    }
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

  public func searchShowsFor(query: String, page: Int) -> AnyPublisher<TVShowPage, DataTransferError> {
    return showsPageRemoteDataSource.searchShowsFor(query: query, page: page)
      .map { self.mapper.mapTVShowPage($0, imageBasePath: self.imageBasePath, imageSize: .medium) }
      .eraseToAnyPublisher()
  }
}
