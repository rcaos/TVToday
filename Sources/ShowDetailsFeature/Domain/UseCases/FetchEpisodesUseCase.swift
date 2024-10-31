//
//  Created by Jeans Ruiz on 1/20/20.
//

protocol FetchEpisodesUseCase {
  func execute(request: FetchEpisodesUseCaseRequestValue) async throws -> TVShowSeason
}

struct FetchEpisodesUseCaseRequestValue {
  let showIdentifier: Int
  let seasonNumber: Int
}

// MARK: - DefaultFetchEpisodesUseCase
final class DefaultFetchEpisodesUseCase: FetchEpisodesUseCase {

  private let episodesRepository: TVEpisodesRepository

  init(episodesRepository: TVEpisodesRepository) {
    self.episodesRepository = episodesRepository
  }

  func execute(request: FetchEpisodesUseCaseRequestValue) async throws -> TVShowSeason {
    return try await episodesRepository.fetchEpisodesList(
      for: request.showIdentifier,
      season: request.seasonNumber
    )
  }
}
