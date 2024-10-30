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
      return mapper.mapTVShowPage(dto, imageBasePath: imageBasePath, imageSize: .medium)
    } catch {
      #warning("todo: log error, reseach error and logging strategies")
      return nil
    }
  }

  public func fetchPopularShows(page: Int) async -> TVShowPage? {
    do {
      let dto = try await showsPageRemoteDataSource.fetchPopularShows(page: page)
      return mapper.mapTVShowPage(dto, imageBasePath: imageBasePath, imageSize: .medium)
    } catch {
      #warning("todo: log error, reseach error and logging strategies")
      return nil
    }
  }

  public func fetchShowsByGenre(genreId: Int, page: Int) async -> TVShowPage? {
    do {
      let dto = try await showsPageRemoteDataSource.fetchShowsByGenre(genreId: genreId, page: page)
      return mapper.mapTVShowPage(dto, imageBasePath: imageBasePath, imageSize: .medium)
    } catch {
      #warning("todo: log error, reseach error and logging strategies")
      return nil
    }
  }

  public func searchShowsFor(query: String, page: Int) async -> TVShowPage? {
    do {
      let deto = try await showsPageRemoteDataSource.searchShowsFor(query: query, page: page)
      return mapper.mapTVShowPage(deto, imageBasePath: imageBasePath, imageSize: .medium)
    } catch {
      #warning("todo: log error, reseach error and logging strategies")
      return nil
    }
  }
}
