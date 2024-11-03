//
//  Created by Jeans Ruiz on 1/16/20.
//

import Foundation
import NetworkingInterface
import Persistence
import Shared
import UI

public protocol FetchTVShowDetailsUseCase {
  func execute(request: FetchTVShowDetailsUseCaseRequestValue) async throws -> TVShowDetail
}

public struct FetchTVShowDetailsUseCaseRequestValue {
  let identifier: Int
}

public final class DefaultFetchTVShowDetailsUseCase: FetchTVShowDetailsUseCase {
  private let tvShowDetailsRepository: TVShowsDetailsRepository
  private let tvShowsVisitedRepository: ShowsVisitedLocalRepositoryProtocol

  public init(
    tvShowDetailsRepository: TVShowsDetailsRepository,
    tvShowsVisitedRepository: ShowsVisitedLocalRepositoryProtocol
  ) {
    self.tvShowDetailsRepository = tvShowDetailsRepository
    self.tvShowsVisitedRepository = tvShowsVisitedRepository
  }

  public func execute(request: FetchTVShowDetailsUseCaseRequestValue) async throws -> TVShowDetail {
    let showDetails = try await tvShowDetailsRepository.fetchTVShowDetails(with: request.identifier)
    tvShowsVisitedRepository.saveShow(id: showDetails.id, pathImage: showDetails.posterPathURL?.absoluteString ?? "")
    return showDetails
  }
}
