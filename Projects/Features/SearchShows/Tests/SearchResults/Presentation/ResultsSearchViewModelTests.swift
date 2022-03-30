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
      searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)

    // when

    let expected = ResultViewState.initial
    var countValuesReceived = 0

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        // then
        countValuesReceived += 1
        XCTAssertEqual(expected, value, "ResultsSearchViewModel should contains loading State")
      })
      .store(in: &disposeBag)

    // then
    XCTAssertEqual(1, countValuesReceived, "Should only receives one Value")
  }

  func test_When_Use_Case_Responds_Successfully_Should_ViewModel_Contains_Recents_Searchs() {
    // given
    let recent = ["Breaking Bad", "Rick and Morty", "Dark"]
    fetchSearchsUseCaseMock.result = recent.map { Search(query: $0) }

    sut = ResultsSearchViewModel(
                searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)

    // when
    let expected = [
      [],
      createSectionModel(recentSearchs: recent, resultShows: [])
    ]
    var received = [[ResultSearchSectionModel]]()

    sut.dataSource
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // then
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(expected, received, "Should contains 2 values")
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
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(expected, received, "Should contains 2 values")
  }

//      context("When Search Use Case response with no results") {
//        it("Should ViewModel contains Empty State") {
//
//          // given
//          searchTVShowsUseCaseMock.result = TVShowResult(page: 1, results: [], totalResults: 0, totalPages: 0)
//
//          let viewModel: ResultsSearchViewModelProtocol = ResultsSearchViewModel(
//            searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)
//
//          // when
//          viewModel.searchShows(with: "something")
//
//          // then
//          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
//          guard let currentViewState = viewState else {
//            fail("It should emit a View State")
//            return
//          }
//
//          let expected = ResultViewState.empty
//
//          expect(currentViewState).toEventually(equal(expected))
//        }
//      }
//
//      context("When Search Use Case response With Shows") {
//        it("Should ViewModel contains Populated State") {
//
//          // given
//          let shows: [TVShow] = [
//            TVShow.stub(id: 1, name: "Show 1"),
//            TVShow.stub(id: 2, name: "Show 2")
//          ]
//          searchTVShowsUseCaseMock.result = TVShowResult(page: 1, results: shows, totalResults: 1, totalPages: 1)
//
//          let viewModel: ResultsSearchViewModelProtocol = ResultsSearchViewModel(
//            searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)
//
//          // when
//          viewModel.searchShows(with: "something")
//
//          // then
//          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
//          guard let currentViewState = viewState else {
//            fail("It should emit a View State")
//            return
//          }
//
//          let expected = ResultViewState.populated
//
//          expect(currentViewState).toEventually(equal(expected))
//        }
//      }
//
//      context("When Search Use Case response With Shows") {
//        it("Should ViewModel contains Shows") {
//
//          // given
//          let shows: [TVShow] = [
//            TVShow.stub(id: 1, name: "something Show 1"),
//            TVShow.stub(id: 2, name: "something Show 2")
//          ]
//          let expectedData = self.createSectionModel(recentSearchs: [], resultShows: shows)
//
//          searchTVShowsUseCaseMock.result = TVShowResult(page: 1, results: shows, totalResults: 1, totalPages: 1)
//
//          let viewModel: ResultsSearchViewModelProtocol = ResultsSearchViewModel(
//            searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)
//
//          // when
//          viewModel.searchShows(with: "something")
//
//          // then
//          let data = try? viewModel.dataSource.toBlocking(timeout: 2).first()
//          guard let dataSource = data else {
//            fail("It should emit a View State")
//            return
//          }
//
//          expect(dataSource).toEventually(equal(expectedData))
//        }
//      }
//
//      context("When Search Use Case response With Error") {
//        it("Should ViewModel contains Error State") {
//
//          // given
//          searchTVShowsUseCaseMock.error = CustomError.genericError
//
//          let viewModel: ResultsSearchViewModelProtocol = ResultsSearchViewModel(
//            searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)
//
//          // when
//          viewModel.searchShows(with: "something")
//
//          // then
//          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
//          guard let currentViewState = viewState else {
//            fail("It should emit a View State")
//            return
//          }
//
//          let expected = ResultViewState.error(CustomError.genericError.localizedDescription)
//
//          expect(currentViewState).toEventually(equal(expected))
//        }
//      }
//    }
//  }

  // MARK: - Map Results
  fileprivate func createSectionModel(recentSearchs: [String], resultShows: [TVShow]) -> [ResultSearchSectionModel] {
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
