//
//  Created by Jeans Ruiz on 30/04/22.
//

import Foundation

public final class DefaultTVShowPageMapper: TVShowPageMapperProtocol {

  public init() { }

  public func mapTVShowPage(_ page: TVShowPageDTO, imageBasePath: String, imageSize: ImageSize) -> TVShowPage {
    let shows = page.showsList.compactMap { self.mapTVShow($0, imageBasePath: imageBasePath, imageSize: imageSize) }
    return TVShowPage(page: page.page,
                      showsList: shows,
                      totalPages: page.totalPages,
                      totalShows: page.totalShows
    )
  }

  private func mapTVShow(_ show: TVShow2DTO, imageBasePath: String, imageSize: ImageSize) -> TVShowPage.TVShow {

    // MARK: - TODO, handle here placeholder poster and backdrop
    let posterPath = show.posterPath ?? ""
    let posterPathURL = URL(string: "\(imageBasePath)/t/p/\(imageSize.rawValue)\(posterPath)")
    let backPath = show.backDropPath ?? ""
    let backPathURL = URL(string: "\(imageBasePath)/t/p/\(imageSize.rawValue)\(backPath)")

    return TVShowPage.TVShow(
      id: show.id,
      name: show.name,
      overview: show.overview,
      firstAirDate: show.firstAirDate ?? "",  // MARK: - TODO, handle Empty air date
      posterPath: posterPathURL,
      backDropPath: backPathURL,
      genreIds: show.genreIds ?? [],
      voteAverage: show.voteAverage,
      voteCount: show.voteCount
    )
  }
}
