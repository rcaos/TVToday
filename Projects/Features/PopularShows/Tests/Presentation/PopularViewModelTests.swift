//
//  PopularViewModelTests.swift
//  PopularShows-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

// swiftlint:disable all

import Combine
import XCTest
@testable import PopularShows
@testable import Shared

class PopularViewModelTests: XCTestCase {

  private let emptyPage = TVShowResult.stub(page: 1, results: [], totalResults: 0, totalPages: 1)

  private var fetchUseCaseMock: FetchShowsUseCaseMock!
  private var disposeBag: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    fetchUseCaseMock = FetchShowsUseCaseMock()
    disposeBag = []
  }

  func test_When_UseCase_Doesnot_Responds_Yet_ViewModel_Should_Contains_Loading_State() {
    // given
    let sut: PopularViewModelProtocol
    sut = PopularViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)

    // when
    sut.viewDidLoad()

    let expected = SimpleViewState<TVShowCellViewModel>.loading

    var countValuesReceived = 0
    sut.viewStateObservableSubject
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

  func test_when_useCase_respons_with_FirstPage_ViewModel_Should_contains_Populated_State() {
    // given
    fetchUseCaseMock.result = buildFirstPage()
    let firstPageCells = buildFirstPage().results!.map { TVShowCellViewModel(show: $0) }

    let sut: PopularViewModelProtocol = PopularViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)

    let expected = [
      SimpleViewState<TVShowCellViewModel>.loading,
      SimpleViewState<TVShowCellViewModel>.paging(firstPageCells, next: 2)
    ]
    var received = [SimpleViewState<TVShowCellViewModel>]()

    sut.viewStateObservableSubject
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

  func test_When_ask_for_second_page_ViewModel_Should_contains_Populated_State_with_Second_Page() {
    // given
    let sut: PopularViewModelProtocol = PopularViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)
    let firstPage = buildFirstPage().results!.map { TVShowCellViewModel(show: $0) }
    let secondPage = (buildFirstPage().results + buildSecondPage().results).map { TVShowCellViewModel(show: $0) }

    let expected = [
      SimpleViewState<TVShowCellViewModel>.loading,
      SimpleViewState<TVShowCellViewModel>.paging(firstPage, next: 2),
      SimpleViewState<TVShowCellViewModel>.populated(secondPage)
    ]

    var received = [SimpleViewState<TVShowCellViewModel>]()

    sut.viewStateObservableSubject
      .removeDuplicates()
      .print()
      .sink(receiveCompletion: { _ in } , receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    fetchUseCaseMock.result = buildFirstPage()
    sut.viewDidLoad()

    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)

    // and when
    fetchUseCaseMock.result = buildSecondPage()
    sut.didLoadNextPage()

    // then
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(expected, received, "Should contains 3 values")
  }


//      context("When Fetch Use Case Returns Error") {
//        it("Should ViewModel contanins Error") {
//          // given
//          fetchUseCaseMock.error = CustomError.genericError
//
//          let viewModel: PopularViewModelProtocol = PopularViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)
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
//          let expected = SimpleViewState<TVShowCellViewModel>.error("")
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
//          let viewModel: PopularViewModelProtocol = PopularViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)
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
//          let expected = SimpleViewState<TVShowCellViewModel>.empty
//
//          expect(currentViewState).toEventually(equal(expected))
//        }
//      }
//    }
//  }
//}
}
