//
//  DefaultTVShowDetailsMapper.swift
//  
//
//  Created by Jeans Ruiz on 4/05/22.
//

import Foundation

public final class DefaultTVShowDetailsMapper: TVShowDetailsMapper {

  public init() { }

  public func mapTVShow(_ show: TVShowDetailDTO, imageBasePath: String, imageSize: ImageSize) -> TVShowDetail {
    let posterPath = show.posterPath ?? ""
    let posterPathURL = URL(string: "\(imageBasePath)/t/p/\(imageSize.rawValue)\(posterPath)")
    let backPath = show.backDropPath ?? ""
    let backPathURL = URL(string: "\(imageBasePath)/t/p/\(imageSize.rawValue)\(backPath)")

    let genres = show.genreIds?.map { Genre(id: $0.id, name: $0.name) } ?? []

    return TVShowDetail(
      id: show.id,
      name: show.name,
      firstAirDate: show.firstAirDate ?? "",
      lastAirDate: show.lastAirDate ?? "",
      episodeRunTime: show.episodeRunTime ?? [],
      genreIds: genres,
      numberOfEpisodes: show.numberOfEpisodes ?? 0,
      numberOfSeasons: show.numberOfSeasons ?? 0,
      posterPathURL: posterPathURL,
      backDropPathURL: backPathURL,
      overview: show.overview ?? "",
      voteAverage: show.voteAverage ?? 0.0,
      voteCount: show.voteCount ?? 0,
      status: show.status ?? ""
    )
  }
}
