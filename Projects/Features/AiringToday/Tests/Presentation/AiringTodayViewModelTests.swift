//
//  AiringTodayViewModelTests.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

// swiftlint:disable all

@testable import AiringToday
@testable import Shared
import XCTest

class AiringTodayViewModelTests: XCTestCase {

  let firstShow = TVShow.stub(id: 1, name: "title1 🐶", posterPath: "/1",
                              backDropPath: "/back1", overview: "overview")
  let secondShow = TVShow.stub(id: 2, name: "title2 🔫", posterPath: "/2",
                               backDropPath: "/back2", overview: "overview2")
  let thirdShow = TVShow.stub(id: 3, name: "title3 🚨", posterPath: "/3",
                              backDropPath: "/back3", overview: "overview3")

  lazy var firstPage = TVShowResult.stub(page: 1,
                                         results: [firstShow, secondShow],
                                         totalResults: 3,
                                         totalPages: 2)

  lazy var secondPage = TVShowResult.stub(page: 2,
                                          results: [thirdShow],
                                          totalResults: 3,
                                          totalPages: 2)

  let emptyPage = TVShowResult.stub(page: 1, results: [], totalResults: 0, totalPages: 1)

  var fetchUseCaseMock: FetchShowsUseCaseMock!

  override func setUp() {
    super.setUp()
    fetchUseCaseMock = FetchShowsUseCaseMock()
  }

  func test_When_UseCase_Doesnot_Responds_Yet_ViewModel_Should_Contains_Loading_State() {
    // given
    let sut: AiringTodayViewModelProtocol
    sut = AiringTodayViewModel(
      fetchTVShowsUseCase: self.fetchUseCaseMock, coordinator: nil)

    // when
    sut.viewDidLoad()

    // then
    let expected = SimpleViewState<AiringTodayCollectionViewModel>.loading
    XCTAssertEqual(expected, sut.viewStateObservableSubject.value,
                   "AiringTodayViewModel should contains loading State")
  }

//  override func spec() {
//    describe("AiringTodayViewModel") {
//      var fetchUseCaseMock: FetchShowsUseCaseMock!
//      beforeEach {
//        fetchUseCaseMock = FetchShowsUseCaseMock()
//      }
//
//      context("When waiting for response of Fetch Use Case") {
//        it("Should ViewModel contanins Loading State") {
//          // given
//          // not response yet
//
//          let viewModel: AiringTodayViewModelProtocol = AiringTodayViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)
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
//          let expected = SimpleViewState<AiringTodayCollectionViewModel>.loading
//
//          expect(currentViewState).toEventually(equal(expected))
//        }
//      }

//      context("When Fetch Use Case Retrieve First page") {
//        it("Should ViewModel contains only First page") {
//          // given
//          fetchUseCaseMock.result = self.firstPage
//          let firstPageCells = self.firstPage.results!.map { AiringTodayCollectionViewModel(show: $0) }
//
//          let viewModel: AiringTodayViewModelProtocol = AiringTodayViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)
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
//          let expected = SimpleViewState<AiringTodayCollectionViewModel>.paging(firstPageCells, next: 2)
//
//          expect(currentViewState).toEventually(equal(expected))
//        }
//      }
//
//      context("When Fetch Use Case Retrieve First and Second Page") {
//        it("Should ViewModel contains First and Second page") {
//
//          let totalCells = (self.firstPage.results + self.secondPage.results)
//            .map { AiringTodayCollectionViewModel(show: $0) }
//
//          // given
//          fetchUseCaseMock.result = self.firstPage
//
//          let viewModel: AiringTodayViewModelProtocol = AiringTodayViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)
//
//          // when
//          viewModel.viewDidLoad()
//          fetchUseCaseMock.result = self.secondPage
//          viewModel.didLoadNextPage()
//
//          // then
//          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
//          guard let currentViewState = viewState else {
//            fail("It should emit a View State")
//            return
//          }
//          let expected = SimpleViewState<AiringTodayCollectionViewModel>.populated(totalCells)
//
//          expect(currentViewState).toEventually(equal(expected))
//        }
//      }
//
//      context("When Fetch Use Case Returns Error") {
//        it("Should ViewModel contanins Error") {
//          // given
//          fetchUseCaseMock.error = CustomError.genericError
//
//          let viewModel = AiringTodayViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)
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
//          let expected = SimpleViewState<AiringTodayCollectionViewModel>.error("")
//
//          expect(currentViewState).toEventually(equal(expected))
//        }
//      }
//
//      context("When Fetch Use Case Returns Zero Shows") {
//        it("Should ViewModel contanins Empty State") {
//          // given
//          fetchUseCaseMock.result = self.emptyPage
//
//          let viewModel = AiringTodayViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)
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
//          let expected = SimpleViewState<AiringTodayCollectionViewModel>.empty
//
//          expect(currentViewState).toEventually(equal(expected))
//        }
//      }
//    }
//  }
}
