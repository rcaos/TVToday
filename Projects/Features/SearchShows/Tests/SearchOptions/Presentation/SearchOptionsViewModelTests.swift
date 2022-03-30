//
//  PopularViewModelTests.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

// swiftlint:disable all

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
        XCTAssertEqual(expected, value, "AiringTodayViewModel should contains loading State")
      })
      .store(in: &disposeBag)

    // then
    XCTAssertEqual(1, countValuesReceived, "Should only receives one Value")
  }

//      context("When Fetch Use Case Retrieve Data") {
//        it("Should ViewModel contains Populated State") {
//
//          // given
//          fetchGenresUseCaseMock.result = GenreListResult(genres: self.genres )
//          recentsDidChangeUseCaseMock.result = true
//          fetchVisitedShowsUseCaseMock.result = self.showsVisited
//
//          let viewModel: SearchOptionsViewModelProtocol =  SearchOptionsViewModel(
//            fetchGenresUseCase: fetchGenresUseCaseMock,
//            fetchVisitedShowsUseCase: fetchVisitedShowsUseCaseMock,
//            recentVisitedShowsDidChange: recentsDidChangeUseCaseMock)
//
//          // when
//          viewModel.viewDidLoad()
//
//          // then
//          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
//          guard let currentViewState = viewState else {
//            fail("It should emit a View State")
//            return
//          }
//          let expected =  SearchViewState.populated
//
//          expect(currentViewState).toEventually(equal(expected))
//        }
//      }
//
//      context("When Fetch Use Case Returns Zero elements") {
//        it("Should ViewModel contanins Empty State") {
//          // given
//          fetchGenresUseCaseMock.result = GenreListResult(genres: [] )
//          recentsDidChangeUseCaseMock.result = true
//          fetchVisitedShowsUseCaseMock.result = self.showsVisited
//
//          let viewModel: SearchOptionsViewModelProtocol =  SearchOptionsViewModel(
//            fetchGenresUseCase: fetchGenresUseCaseMock,
//            fetchVisitedShowsUseCase: fetchVisitedShowsUseCaseMock,
//            recentVisitedShowsDidChange: recentsDidChangeUseCaseMock)
//
//          // when
//          viewModel.viewDidLoad()
//
//          // then
//          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
//          guard let currentViewState = viewState else {
//            fail("It should emit a View State")
//            return
//          }
//          let expected =  SearchViewState.empty
//
//          expect(currentViewState).toEventually(equal(expected))
//        }
//      }
//
//      context("When Fetch Use Case Returns Zero Shows") {
//        it("Should ViewModel contanins Empty State") {
//          // given
//          fetchGenresUseCaseMock.error = CustomError.genericError
//          recentsDidChangeUseCaseMock.result = true
//          fetchVisitedShowsUseCaseMock.result = self.showsVisited
//
//          let viewModel: SearchOptionsViewModelProtocol =  SearchOptionsViewModel(
//            fetchGenresUseCase: fetchGenresUseCaseMock,
//            fetchVisitedShowsUseCase: fetchVisitedShowsUseCaseMock,
//            recentVisitedShowsDidChange: recentsDidChangeUseCaseMock)
//
//          // when
//          viewModel.viewDidLoad()
//
//          // when
//          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
//          guard let currentViewState = viewState else {
//            fail("It should emit a View State")
//            return
//          }
//          let expected = SearchViewState.error(CustomError.genericError.localizedDescription)
//
//          expect(currentViewState).toEventually(equal(expected))
//        }
//      }
//    }
//  }
}
