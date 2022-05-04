//
//  TVShowsRepository.swift   // MARK: - TODO, change name
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface

public protocol TVShowsRepository {
  func fetchAiringTodayShows(page: Int) -> AnyPublisher<TVShowResult, DataTransferError>

  func fetchPopularShows(page: Int) -> AnyPublisher<TVShowResult, DataTransferError>

  func fetchShowsByGenre(genreId: Int, page: Int) -> AnyPublisher<TVShowResult, DataTransferError>

  func searchShowsFor(query: String, page: Int) -> AnyPublisher<TVShowResult, DataTransferError>

  // Maybe another Repository ??
  func fetchTVShowDetails(with showId: Int) -> AnyPublisher<TVShowDetailResult, DataTransferError>
}

// https://developer.android.com/topic/architecture/data-layer
// 1. Repository can contains 0 or Many DataSources
// 2. Create each Repository for each DIFFERENT type of Data you Handle (MoviesRepository, PaymentsRepository
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
}

public protocol TVShowsRemoteDataSource {
  // Internally this use DataTransferService
  func fetchAiringTodayShows(page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError>
}

public protocol TVShowPageMapper {
  // init should be have URL base Path String
  func mapTVShowPage(_ page: TVShowPageDTO, imageBasePath: String, imageSize: ImageSize) -> TVShowPage
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
