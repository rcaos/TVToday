//
//  Created by Jeans Ruiz on 1/16/20.
//

import Foundation
import NetworkingInterface
import Persistence
import Shared
import UI

public protocol FetchTVShowDetailsUseCase {
  // MARK: - TODO Use another error maybe?
  func execute(request: FetchTVShowDetailsUseCaseRequestValue) async throws -> TVShowDetail
}

public struct FetchTVShowDetailsUseCaseRequestValue {
  let identifier: Int
}

// MARK: - FetchTVShowDetailsUseCase
public final class DefaultFetchTVShowDetailsUseCase: FetchTVShowDetailsUseCase {
  private let tvShowDetailsRepository: TVShowsDetailsRepository
  
  // wip
  //private let tvShowsVisitedRepository: ShowsVisitedLocalRepositoryProtocol // MARK: - TODO, Move this logic to TVShowsDetailsRepository

  public init(
    tvShowDetailsRepository: TVShowsDetailsRepository
    //tvShowsVisitedRepository: ShowsVisitedLocalRepositoryProtocol
  ) {
    self.tvShowDetailsRepository = tvShowDetailsRepository
    //self.tvShowsVisitedRepository = tvShowsVisitedRepository
  }

  public func execute(request: FetchTVShowDetailsUseCaseRequestValue) async throws -> TVShowDetail {
    let showDetails = try await tvShowDetailsRepository.fetchTVShowDetails(with: request.identifier)
    //await tvsVisitedRepository.saveShow(id: dto.id, pathImage: dto.posterPathURL?.absoluteString ?? "")
    return showDetails
  }
}
