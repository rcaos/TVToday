//
//  TVShowsRepository.swift   // MARK: - TODO, change name
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface

// https://developer.android.com/topic/architecture/data-layer
// 1. Repository can contains 0 or Many DataSources
// 2. Create each Repository for each DIFFERENT type of Data you Handle (MoviesRepository, PaymentsRepository
// 2.1 Each DataSource should work only with ONE source of data (file, Network, local database
// 3. Must returns a Immutable Domain Model (Merge of different dataSources)
// 4. Resolve conflicts between different data Sources and User input
// 5. Each Repository defines a Single Source of Truth (usually a DataSource= local, network or Memory
// 6. Different repositories might have different Sources of Truth (LoginRepository: Keychain, PaymentsRepository: network
// 7. To achieve offline-first, its recommended use LocalDataSource (CoreData) as Source of Truth
// 8. Types of Operations a. from UI, from App and Business operations
// 9. UI-oriented: fetchNews(), lifeCycle related to a UI, Canceled when UI is dismissed
// 10. App oriented: attach to app LifeCycle, canceled when app is Killed
// 11. Business-oriented: upload a photo,
// 12. What kind of Errors expose, Use Result<Error, Data> with a Never instead??
// 13. What if I need the response survives if the user leaves the screen. Cancel before do another


// https://proandroiddev.com/the-real-repository-pattern-in-android-efba8662b754
// 1. DataSource returns a DTO
// 2. Mapper, recieves DTO and returns Domain
// 3. Repository returns Domain
// 4. Each Type of DataSources needs to use hits own DTO
// 5. One DataSource has to use Only by ONE REPOSITORY !!!!

// DataSources:
// 1. Each DataSource MUST only work with ONE SOURCE of data (File, Network, LocalDataBase

public protocol TVShowsPageRepository {
  func fetchAiringTodayShows(page: Int) -> AnyPublisher<TVShowPage, DataTransferError>
  func fetchPopularShows(page: Int) -> AnyPublisher<TVShowPage, DataTransferError>
  func fetchShowsByGenre(genreId: Int, page: Int) -> AnyPublisher<TVShowPage, DataTransferError>
  func searchShowsFor(query: String, page: Int) -> AnyPublisher<TVShowPage, DataTransferError>
}

public protocol TVShowsDetailsRepository {
  func fetchTVShowDetails(with showId: Int) -> AnyPublisher<TVShowDetail, DataTransferError>
}

public protocol TVShowsRemoteDataSource {
  // Internally this use DataTransferService
  func fetchAiringTodayShows(page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError>
  func fetchPopularShows(page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError>
  func fetchShowsByGenre(genreId: Int, page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError>
  func searchShowsFor(query: String, page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError>
  func fetchTVShowDetails(with showId: Int) -> AnyPublisher<TVShowDetailDTO, DataTransferError>

  func fetchFavoritesShows(page: Int, userId: Int, sessionId: String) -> AnyPublisher<TVShowPageDTO, DataTransferError>
  func fetchWatchListShows(page: Int, userId: Int, sessionId: String) -> AnyPublisher<TVShowPageDTO, DataTransferError>

  func markAsFavorite(tvShowId: Int, userId: String,session: String,  favorite: Bool) -> AnyPublisher<TVShowActionStatusDTO, DataTransferError>
  func saveToWatchList(tvShowId: Int, userId: String, session: String, watchedList: Bool) -> AnyPublisher<TVShowActionStatusDTO, DataTransferError>
  func fetchTVShowStatus(tvShowId: Int, sessionId: String) -> AnyPublisher<TVShowAccountStatusDTO, DataTransferError>
}

public protocol TVShowPageMapper {
  // init should be have URL base Path String
  func mapTVShowPage(_ page: TVShowPageDTO, imageBasePath: String, imageSize: ImageSize) -> TVShowPage
}

public protocol TVShowDetailsMapper {
  func mapTVShow(_ show: TVShowDetailDTO, imageBasePath: String, imageSize: ImageSize) -> TVShowDetail
}

public protocol AccountTVShowsDetailsMapperProtocol {
  func mapActionResult(result: TVShowActionStatusDTO) -> TVShowActionStatus
  func mapTVShowStatusResult(result: TVShowAccountStatusDTO) -> TVShowAccountStatus
}

public enum ImageSize: String {
  case medium = "w780"
}

// CoreDataSource
//public protocol TVShowsLocalDataSource {
//  func fetchAiringTodayShows(page: Int) -> AnyPublisher<TVShowPageLocal, DataTransferError>
//}

// Memory DataSource
//public protocol TVShowsMemoryDataSource {
//  func fetchAiringTodayShows(page: Int) -> AnyPublisher<TVShowsPageMemory, DataTransferError>
//}
