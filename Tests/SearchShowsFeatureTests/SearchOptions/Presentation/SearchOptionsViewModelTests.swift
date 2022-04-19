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
                                 recentVisitedShowsDidChange: recentsDidChangeUseCaseMock,
                                 scheduler: .immediate)

    // when
    sut.viewDidLoad()

    var received = [SearchViewState]()
    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // then
    XCTAssertEqual([.loading], received)
  }

  func test_when_useCase_Responds_Success_ViewModel_Should_contains_Populated_State() {
    // given
    fetchGenresUseCaseMock.result = GenreListResult(genres: buildGenres() )
              recentsDidChangeUseCaseMock.result = true
              fetchVisitedShowsUseCaseMock.result = buildShowVisited()

    sut = SearchOptionsViewModel(
                fetchGenresUseCase: fetchGenresUseCaseMock,
                fetchVisitedShowsUseCase: fetchVisitedShowsUseCaseMock,
                recentVisitedShowsDidChange: recentsDidChangeUseCaseMock,
                scheduler: .immediate)

    var received = [SearchViewState]()
    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual([.loading, .populated], received)
  }

  func test_when_useCase_Responds_With_Zero_Elements_ViewModel_Should_contains_Empty_State() {
    // given
    fetchGenresUseCaseMock.result = GenreListResult(genres: [] )
    recentsDidChangeUseCaseMock.result = true
    fetchVisitedShowsUseCaseMock.result = buildShowVisited()

    sut = SearchOptionsViewModel(
                fetchGenresUseCase: fetchGenresUseCaseMock,
                fetchVisitedShowsUseCase: fetchVisitedShowsUseCaseMock,
                recentVisitedShowsDidChange: recentsDidChangeUseCaseMock,
                scheduler: .immediate)

    var received = [SearchViewState]()
    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual([.loading, .empty], received)
  }

  func test_when_useCase_Responds_With_Error_ViewModel_Should_contains_Error_State() {
    // given
    fetchGenresUseCaseMock.error = .noResponse
    recentsDidChangeUseCaseMock.result = true
    fetchVisitedShowsUseCaseMock.result = buildShowVisited()

    sut = SearchOptionsViewModel(
                fetchGenresUseCase: fetchGenresUseCaseMock,
                fetchVisitedShowsUseCase: fetchVisitedShowsUseCaseMock,
                recentVisitedShowsDidChange: recentsDidChangeUseCaseMock,
                scheduler: .immediate)

    var received = [SearchViewState]()
    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // MARK: - TODO, test recovery from error also

    // then
    XCTAssertEqual([.loading, .error("")], received, "Should contains 2 values")
  }
}
