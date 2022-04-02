//
//  PopularViewModelTests.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

import XCTest
import Combine
@testable import SearchShows
@testable import Persistence
@testable import Shared

class SearchOptionsViewModelTest: XCTestCase {

  private var sut: SearchOptionsViewModelProtocol!
  private var fetchGenresUseCaseMock: FetchGenresUseCaseMock!
  private var fetchVisitedShowsUseCaseMock: FetchVisitedShowsUseCaseMock!
  private var recentsDidChangeUseCaseMock: RecentVisitedShowDidChangeUseCaseMock!
  private var disposeBag: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    sut = nil
    fetchVisitedShowsUseCaseMock = FetchVisitedShowsUseCaseMock()
    fetchGenresUseCaseMock = FetchGenresUseCaseMock()
    recentsDidChangeUseCaseMock = RecentVisitedShowDidChangeUseCaseMock()
    disposeBag = []
  }

  func test_When_UseCase_Doesnot_Responds_Yet_ViewModel_Should_Contains_Loading_State() {
    // given
    sut = SearchOptionsViewModel(fetchGenresUseCase: fetchGenresUseCaseMock,
                                 fetchVisitedShowsUseCase: fetchVisitedShowsUseCaseMock,
                                 recentVisitedShowsDidChange: recentsDidChangeUseCaseMock)

    // when
    sut.viewDidLoad()

    let expected = SearchViewState.loading
    var countValuesReceived = 0

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        // then
        countValuesReceived += 1
        XCTAssertEqual(expected, value, "SearchOptionsViewModel should contains loading State")
      })
      .store(in: &disposeBag)

    // then
    XCTAssertEqual(1, countValuesReceived, "Should only receives one Value")
  }

  func test_when_useCase_Responds_Success_ViewModel_Should_contains_Populated_State() {
    // given
    fetchGenresUseCaseMock.result = GenreListResult(genres: buildGenres() )
              recentsDidChangeUseCaseMock.result = true
              fetchVisitedShowsUseCaseMock.result = buildShowVisited()

    sut = SearchOptionsViewModel(
                fetchGenresUseCase: fetchGenresUseCaseMock,
                fetchVisitedShowsUseCase: fetchVisitedShowsUseCaseMock,
                recentVisitedShowsDidChange: recentsDidChangeUseCaseMock)
    let expected = [
      SearchViewState.loading,
      SearchViewState.populated
    ]
    var received = [SearchViewState]()

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(expected, received, "Should contains 2 values")
  }

  func test_when_useCase_Responds_With_Zero_Elements_ViewModel_Should_contains_Empty_State() {
    // given
    fetchGenresUseCaseMock.result = GenreListResult(genres: [] )
    recentsDidChangeUseCaseMock.result = true
    fetchVisitedShowsUseCaseMock.result = buildShowVisited()

    sut = SearchOptionsViewModel(
                fetchGenresUseCase: fetchGenresUseCaseMock,
                fetchVisitedShowsUseCase: fetchVisitedShowsUseCaseMock,
                recentVisitedShowsDidChange: recentsDidChangeUseCaseMock)
    let expected = [
      SearchViewState.loading,
      SearchViewState.empty
    ]
    var received = [SearchViewState]()

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(expected, received, "Should contains 2 values")
  }

  func test_when_useCase_Responds_With_Error_ViewModel_Should_contains_Error_State() {
    // given
    fetchGenresUseCaseMock.error = .noResponse
    recentsDidChangeUseCaseMock.result = true
    fetchVisitedShowsUseCaseMock.result = buildShowVisited()

    sut = SearchOptionsViewModel(
                fetchGenresUseCase: fetchGenresUseCaseMock,
                fetchVisitedShowsUseCase: fetchVisitedShowsUseCaseMock,
                recentVisitedShowsDidChange: recentsDidChangeUseCaseMock)
    let expected = [
      SearchViewState.loading,
      SearchViewState.error("")
    ]
    var received = [SearchViewState]()

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(expected, received, "Should contains 2 values")
  }
}
