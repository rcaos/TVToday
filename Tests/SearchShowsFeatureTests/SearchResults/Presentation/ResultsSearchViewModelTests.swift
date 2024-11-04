//
//  Created by Jeans Ruiz on 8/7/20.
//

import CommonMocks
import XCTest
import Combine

@testable import SearchShowsFeature
import Persistence
import Shared
import UI
import NetworkingInterface

#warning("todo, recover these tests")
class ResultsSearchViewModelTests: XCTestCase {

  private var sut: ResultsSearchViewModelProtocol!
  var searchTVShowsUseCaseMock: SearchTVShowsUseCaseMock!
  var fetchSearchsUseCaseMock: FetchSearchsUseCaseMock!

  private var disposeBag: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    sut = nil
    searchTVShowsUseCaseMock = SearchTVShowsUseCaseMock()
    fetchSearchsUseCaseMock = FetchSearchsUseCaseMock()
    disposeBag = []
  }

  func test_Restuts_is_Create_Should_Contains_Initial_State() {
    // given
    sut = ResultsSearchViewModel(
      searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchesUseCase: fetchSearchsUseCaseMock)

    var received = [ResultViewState]()
    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0)}).store(in: &disposeBag)

    // when
    // anything

    // then
    XCTAssertEqual([.initial], received)
  }

  func test_When_Use_Case_Responds_Successfully_Should_ViewModel_Contains_Recents_Searchs() {
    // given
    let recent = ["Breaking Bad", "Rick and Morty", "Dark"]
    fetchSearchsUseCaseMock.result = recent.map { Search(query: $0) }

    sut = ResultsSearchViewModel(
      searchTVShowsUseCase: searchTVShowsUseCaseMock,
      fetchRecentSearchesUseCase: fetchSearchsUseCaseMock
    )

    // when
    let expected = [
      createSectionModel(recentSearchs: recent, resultShows: [])
    ]
    var received = [[ResultSearchSectionModel]]()

    sut.dataSource.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // then
    XCTAssertEqual(expected, received)
  }

  func test_When_Use_Case_DoestNot_Respond_yet_Should_ViewModel_Contains_Loading_State() {
    // given
    sut = ResultsSearchViewModel(
      searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchesUseCase: fetchSearchsUseCaseMock)

    var received = [ResultViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.searchShows(with: "something")

    // then
    XCTAssertEqual([.initial, .loading], received)
  }

  func test_When_Use_Case_Respond_with_Zero_Values_Should_ViewModel_Contains_Loading_State() {
    // given
    searchTVShowsUseCaseMock.result = TVShowPage(page: 1, showsList: [], totalPages: 0, totalShows: 0)
    sut = ResultsSearchViewModel(
      searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchesUseCase: fetchSearchsUseCaseMock)

    var received = [ResultViewState]()
    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.searchShows(with: "something")

    // then
    XCTAssertEqual([.initial, .loading, .empty], received)
  }

  func test_When_Use_Case_Respond_With_Data_Should_ViewModel_Contains_Populated_State() {
    // given
    let shows = [TVShowPage.TVShow.stub(id: 1, name: "Show 1")]
    searchTVShowsUseCaseMock.result = TVShowPage(page: 1, showsList: shows, totalPages: 1, totalShows: 1)

    sut = ResultsSearchViewModel(
      searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchesUseCase: fetchSearchsUseCaseMock)

    var received = [ResultViewState]()
    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.searchShows(with: "something")

    // then
    XCTAssertEqual([.initial, .loading, .populated], received)
  }

  func test_When_Use_Case_Respond_With_Data_Should_ViewModel_DataSource_Contains_Data() {
    // given
    let shows: [TVShowPage.TVShow] = [
      .stub(id: 1, name: "something Show 1"),
      .stub(id: 2, name: "something Show 2")
    ]

    searchTVShowsUseCaseMock.result = TVShowPage(page: 1, showsList: shows, totalPages: 1, totalShows: 2)
    sut = ResultsSearchViewModel(
      searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchesUseCase: fetchSearchsUseCaseMock)

    let expected = [
      [],
      createSectionModel(recentSearchs: [], resultShows: shows)
    ]
    var received = [[ResultSearchSectionModel]]()

    sut.dataSource.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.searchShows(with: "something")

    // then
    XCTAssertEqual(expected, received)
  }

  func test_When_Use_Case_Respond_With_Error_Should_ViewModel_Contains_Error_State() {
    // given
    searchTVShowsUseCaseMock.error = ApiError(error: NSError(domain: "", code: 0, userInfo: nil))
    sut = ResultsSearchViewModel(
      searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchesUseCase: fetchSearchsUseCaseMock)

    var received = [ResultViewState]()
    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.searchShows(with: "something")

    // MARK: - TODO, test, recovery from error also

    // then
    XCTAssertEqual([.initial, .loading, .error("")], received)
  }

  // MARK: - Map Results
  private func createSectionModel(recentSearchs: [String], resultShows: [TVShowPage.TVShow]) -> [ResultSearchSectionModel] {
    var dataSource: [ResultSearchSectionModel] = []

    let recentSearchsItem = recentSearchs.map { ResultSearchSectionItem.recentSearchs(items: $0) }

    let resultsShowsItem = resultShows
      .map { TVShowCellViewModel(show: $0) }
      .map { ResultSearchSectionItem.results(items: $0) }

    if !recentSearchsItem.isEmpty {
      dataSource.append(.recentSearchs(items: recentSearchsItem))
    }

    if !resultsShowsItem.isEmpty {
      dataSource.append(.results(items: resultsShowsItem))
    }

    return dataSource
  }
}
