//
//  Created by Jeans Ruiz on 7/28/20.
//

// swiftlint:disable all

import Foundation
import CommonMocks
import Combine
import XCTest
@testable import ShowListFeature
import Shared
import UI
import NetworkingInterface

class TVShowListViewModelTests: XCTestCase {
  private var fetchUseCaseMock: FetchShowsUseCaseMock!
  private var disposeBag: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    fetchUseCaseMock = FetchShowsUseCaseMock()
    disposeBag = []
  }

  func test_When_UseCase_Doesnot_Responds_Yet_ViewModel_Should_Contains_Loading_State() async {
    // given
    let sut: TVShowListViewModelProtocol
    sut = TVShowListViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)

    let expected = [SimpleViewState<TVShowCellViewModel>.loading]
    var received = [SimpleViewState<TVShowCellViewModel>]()

    sut.viewStateObservableSubject.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    let task = Task { await sut.viewDidLoad() }
    await Task.yield()

    // then
    XCTAssertEqual(expected, received, "Should only receives one Value")
  }

  func test_when_useCase_respons_with_FirstPage_ViewModel_Should_contains_Populated_State() async {
    // given
    fetchUseCaseMock.result = buildFirstPage()
    let firstPageCells = buildFirstPage().showsList.map { TVShowCellViewModel(show: $0) }

    let sut: TVShowListViewModelProtocol = TVShowListViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)

    let expected = [
      SimpleViewState<TVShowCellViewModel>.loading,
      SimpleViewState<TVShowCellViewModel>.paging(firstPageCells, next: 2)
    ]
    var received = [SimpleViewState<TVShowCellViewModel>]()

    sut.viewStateObservableSubject.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    await sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains 2 values")
  }

  func test_When_ask_for_second_page_ViewModel_Should_contains_Populated_State_with_Second_Page() async {
    // given
    let firstPage = buildFirstPage()
    let secondPage = buildSecondPage()

    let sut: TVShowListViewModelProtocol = TVShowListViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)
    let firstPageModels = firstPage.showsList.map { TVShowCellViewModel(show: $0) }
    let secondPageModels = (firstPage.showsList + secondPage.showsList).map { TVShowCellViewModel(show: $0) }

    let expected = [
      SimpleViewState<TVShowCellViewModel>.loading,
      SimpleViewState<TVShowCellViewModel>.paging(firstPageModels, next: 2),
      SimpleViewState<TVShowCellViewModel>.populated(secondPageModels)
    ]
    var received = [SimpleViewState<TVShowCellViewModel>]()

    sut.viewStateObservableSubject.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    fetchUseCaseMock.result = firstPage
    await sut.viewDidLoad()

    // and when
    fetchUseCaseMock.result = secondPage

    let total = firstPage.showsList.count + secondPage.showsList.count
    await sut.willDisplayRow(total - 1 , outOf: total)

    // then
    XCTAssertEqual(expected, received, "Should contains 3 values")
  }

  func test_When_UseCase_Responds_Error_ViewModel_Should_Contains_Error_State() async {
    // given
    fetchUseCaseMock.error = ApiError(error: NSError(domain: "MockError", code: 0, userInfo: nil))
    let sut: TVShowListViewModelProtocol
    sut = TVShowListViewModel(fetchTVShowsUseCase: self.fetchUseCaseMock, coordinator: nil)

    let expected = [
      SimpleViewState<TVShowCellViewModel>.loading,
      SimpleViewState<TVShowCellViewModel>.error("")
    ]
    var received = [SimpleViewState<TVShowCellViewModel>]()

    sut.viewStateObservableSubject.removeDuplicates()
      .sink(receiveValue: { received.append($0)}).store(in: &disposeBag)

    // when
    await sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "AiringTodayViewModel should contains Error State")
  }

  func test_When_UseCase_Responds_With_Zero_Elements_ViewModel_Should_Contains_Empty_State() async {
    // given
    fetchUseCaseMock.result = .empty
    let sut: TVShowListViewModelProtocol
    sut = TVShowListViewModel(fetchTVShowsUseCase: self.fetchUseCaseMock, coordinator: nil)

    let expected = [
      SimpleViewState<TVShowCellViewModel>.loading,
      SimpleViewState<TVShowCellViewModel>.empty
    ]
    var received = [SimpleViewState<TVShowCellViewModel>]()

    sut.viewStateObservableSubject.removeDuplicates()
      .sink(receiveValue: { received.append($0)}).store(in: &disposeBag)

    // when
    await sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "AiringTodayViewModel should contains Empty State")
  }
}
