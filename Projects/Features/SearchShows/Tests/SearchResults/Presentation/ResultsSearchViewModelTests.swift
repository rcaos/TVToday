//
//  ResultsSearchViewModelTests.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import XCTest
import Combine

@testable import SearchShows
@testable import Persistence
@testable import Shared

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
      searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock, scheduler: .immediate)

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
      fetchRecentSearchsUseCase: fetchSearchsUseCaseMock,
      scheduler: .immediate
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
      searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)

    let expected = [
      ResultViewState.initial,
      ResultViewState.loading
    ]
    var received = [ResultViewState]()

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.searchShows(with: "something")

    // then
    XCTAssertEqual(expected, received, "Should contains 2 values")
  }

  func test_When_Use_Case_Respond_with_Zero_Values_Should_ViewModel_Contains_Loading_State() {
    // given
    searchTVShowsUseCaseMock.result = TVShowResult(page: 1, results: [], totalResults: 0, totalPages: 0)
    sut = ResultsSearchViewModel(
      searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)

    let expected = [
      ResultViewState.initial,
      ResultViewState.loading,
      ResultViewState.empty
    ]
    var received = [ResultViewState]()

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.searchShows(with: "something")

    // then
    XCTAssertEqual(expected, received, "Should contains 2 values")
  }

  func test_When_Use_Case_Respond_With_Data_Should_ViewModel_Contains_Populated_State() {
    // given
    let shows: [TVShow] = [
      TVShow.stub(id: 1, name: "Show 1")
    ]
    searchTVShowsUseCaseMock.result = TVShowResult(page: 1, results: shows, totalResults: 1, totalPages: 1)

    sut = ResultsSearchViewModel(
      searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)

    let expected = [
      ResultViewState.initial,
      ResultViewState.loading,
      ResultViewState.populated
    ]
    var received = [ResultViewState]()

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.searchShows(with: "something")

    // then
    XCTAssertEqual(expected, received, "Should contains 3 values")
  }

  func test_When_Use_Case_Respond_With_Data_Should_ViewModel_DataSource_Contains_Data() {
    // given
    let shows: [TVShow] = [
      TVShow.stub(id: 1, name: "something Show 1"),
      TVShow.stub(id: 2, name: "something Show 2")
    ]

    searchTVShowsUseCaseMock.result = TVShowResult(page: 1, results: shows, totalResults: 1, totalPages: 1)

    sut = ResultsSearchViewModel(
      searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)

    let expected = [
      [],
      createSectionModel(recentSearchs: [], resultShows: shows)
    ]
    var received = [[ResultSearchSectionModel]]()

    sut.dataSource
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.searchShows(with: "something")

    // then
    XCTAssertEqual(expected, received, "Should contains 2 values")
  }

  func test_When_Use_Case_Respond_With_Error_Should_ViewModel_Contains_Error_State() {
    // given
    searchTVShowsUseCaseMock.error = .noResponse
    sut = ResultsSearchViewModel(
      searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)

    let expected = [
      ResultViewState.initial,
      ResultViewState.loading,
      ResultViewState.error("")
    ]
    var received = [ResultViewState]()

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.searchShows(with: "something")

    // then
    XCTAssertEqual(expected, received, "Should contains 3 values")
  }

  // MARK: - Map Results
  private func createSectionModel(recentSearchs: [String], resultShows: [TVShow]) -> [ResultSearchSectionModel] {
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
