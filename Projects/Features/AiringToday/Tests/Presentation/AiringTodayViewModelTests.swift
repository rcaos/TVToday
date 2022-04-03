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
import Combine

class AiringTodayViewModelTests: XCTestCase {

  var fetchUseCaseMock: FetchShowsUseCaseMock!
  var disposeBag: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    fetchUseCaseMock = FetchShowsUseCaseMock()
    disposeBag = []
  }

  func test_When_UseCase_Doesnot_Responds_Yet_ViewModel_Should_Contains_Loading_State() {
    // given
    let sut: AiringTodayViewModelProtocol
    sut = AiringTodayViewModel(
      fetchTVShowsUseCase: self.fetchUseCaseMock,
      scheduler: .immediate,
      coordinator: nil
    )

    // when
    sut.viewDidLoad()

    let expected = [SimpleViewState<AiringTodayCollectionViewModel>.loading]
    var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

    sut.viewStateObservableSubject.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // then
    XCTAssertEqual(1, received.count, "Should only receives one Value")
    XCTAssertEqual(expected, received, "AiringTodayViewModel should contains loading State")
  }

  func test_when_useCase_respons_with_FirstPage_ViewModel_Should_contains_Populated_State() {
    // given
    fetchUseCaseMock.result = buildFirstPage()
    let firstPageCells = buildFirstPage().results!.map { AiringTodayCollectionViewModel(show: $0) }

    let sut: AiringTodayViewModelProtocol =
    AiringTodayViewModel(fetchTVShowsUseCase: fetchUseCaseMock,
                         scheduler: .immediate,
                         coordinator: nil)

    let expected = [
      SimpleViewState<AiringTodayCollectionViewModel>.loading,
      SimpleViewState<AiringTodayCollectionViewModel>.paging(firstPageCells, next: 2)
    ]
    var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

    sut.viewStateObservableSubject.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &self.disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "AiringTodayViewModel Should contains 2 values")
  }

  func test_When_ask_for_second_page_ViewModel_Should_contains_Populated_State_with_Second_Page() {
    // given
    let sut: AiringTodayViewModelProtocol
    sut = AiringTodayViewModel(fetchTVShowsUseCase: fetchUseCaseMock,
                         scheduler: .immediate,
                         coordinator: nil)

    let firstPage = buildFirstPage().results!.map { AiringTodayCollectionViewModel(show: $0) }
    let secondPage = (buildFirstPage().results + buildSecondPage().results).map { AiringTodayCollectionViewModel(show: $0) }

    let expected = [
      SimpleViewState<AiringTodayCollectionViewModel>.loading,
      SimpleViewState<AiringTodayCollectionViewModel>.paging(firstPage, next: 2),
      SimpleViewState<AiringTodayCollectionViewModel>.populated(secondPage)
    ]
    var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

    sut.viewStateObservableSubject.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &self.disposeBag)

    // when
    fetchUseCaseMock.result = buildFirstPage()
    sut.viewDidLoad()

    // and
    fetchUseCaseMock.result = buildSecondPage()
    sut.didLoadNextPage()

    // then
    XCTAssertEqual(expected, received, "Should contains 3 values")
  }

  func test_When_UseCase_Responds_Error_ViewModel_Should_Contains_Error_State() {
    // given
    fetchUseCaseMock.error = .noResponse
    let sut: AiringTodayViewModelProtocol
    sut = AiringTodayViewModel(fetchTVShowsUseCase: self.fetchUseCaseMock,
                               scheduler: .immediate,
                               coordinator: nil)

    let expected = [
      SimpleViewState<AiringTodayCollectionViewModel>.loading,
      SimpleViewState<AiringTodayCollectionViewModel>.error("")
    ]
    var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

    sut.viewStateObservableSubject.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "AiringTodayViewModel should contains Error State")
  }

  func test_When_UseCase_Responds_With_Zero_Elements_ViewModel_Should_Contains_Empty_State() {
    // given
    fetchUseCaseMock.result = .empty
    let sut: AiringTodayViewModelProtocol
    sut = AiringTodayViewModel(
      fetchTVShowsUseCase: self.fetchUseCaseMock,
      scheduler: .immediate,
      coordinator: nil)

    let expected = [
      SimpleViewState<AiringTodayCollectionViewModel>.loading,
      SimpleViewState<AiringTodayCollectionViewModel>.empty
    ]
    var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

    sut.viewStateObservableSubject.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "AiringTodayViewModel should contains Empty State")
  }

  func test_When_UseCase_Responds_Error_And_User_Retry_ViewModel_Should_Contains_Paginated_State() {
    // given
    fetchUseCaseMock.error = .noResponse
    let sut: AiringTodayViewModelProtocol
    sut = AiringTodayViewModel(fetchTVShowsUseCase: self.fetchUseCaseMock,
                               scheduler: .immediate,
                               coordinator: nil)

    let expected = [
      SimpleViewState<AiringTodayCollectionViewModel>.loading,
      SimpleViewState<AiringTodayCollectionViewModel>.error(""),
      SimpleViewState<AiringTodayCollectionViewModel>.paging(
        buildFirstPage().results!.map { AiringTodayCollectionViewModel(show: $0) }, next: 2)
    ]
    var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

    sut.viewStateObservableSubject.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // and
    fetchUseCaseMock.result = buildFirstPage()
    fetchUseCaseMock.error = nil
    sut.refreshView()

    // then
    XCTAssertEqual(expected, received, "AiringTodayViewModel should contains Paginated State")
  }

  func test_Jum_from_State_Paginated_Error_Populated() {
    // given
    let firstPageVM = buildFirstPage().results!.map { AiringTodayCollectionViewModel(show: $0) }
    let secondPageVM = (buildFirstPage().results + buildSecondPage().results).map { AiringTodayCollectionViewModel(show: $0) }

    let sut: AiringTodayViewModelProtocol
    sut = AiringTodayViewModel(fetchTVShowsUseCase: self.fetchUseCaseMock,
                               scheduler: .immediate,
                               coordinator: nil)

    let expected = [
      SimpleViewState<AiringTodayCollectionViewModel>.loading,
      SimpleViewState<AiringTodayCollectionViewModel>.paging(firstPageVM, next: 2),
      SimpleViewState<AiringTodayCollectionViewModel>.populated(secondPageVM)
    ]
    var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

    sut.viewStateObservableSubject.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    fetchUseCaseMock.result = buildFirstPage()
    sut.viewDidLoad()

    // and
    fetchUseCaseMock.result = nil
    fetchUseCaseMock.error = .noResponse
    sut.didLoadNextPage()

    // again
    fetchUseCaseMock.result = buildSecondPage()
    fetchUseCaseMock.error = nil
    sut.didLoadNextPage()

    // then
    XCTAssertEqual(expected, received, "AiringTodayViewModel should contains Paginated State")
  }

}
