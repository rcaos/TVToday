//
//  Created by Jeans Ruiz on 7/28/20.
//

@testable import AiringTodayFeature
@testable import Shared
import XCTest
import Combine
import CommonMocks
import ConcurrencyExtras
import CustomDump
import NetworkingInterface

class AiringTodayViewModelTests: XCTestCase {

  var fetchUseCaseMock: FetchShowsUseCaseMock!
  var disposeBag: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    fetchUseCaseMock = FetchShowsUseCaseMock()
    disposeBag = []
  }

  func test_When_UseCase_Doesnot_Responds_Yet_ViewModel_Should_Contains_Loading_State() async {
    await withMainSerialExecutor {
      // given
      let sut: AiringTodayViewModelProtocol

      sut = AiringTodayViewModel(
        fetchTVShowsUseCase: {
          return FetchShowsUseCaseMock()
        },
        coordinator: nil
      )

      let expected: [SimpleViewState<AiringTodayCollectionViewModel>] = [.loading, .loading]
      var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

      sut.viewStateObservableSubject
        .print("🚨")
        .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

      // when
      let task = Task { await sut.viewDidLoad() }
      await Task.yield() /// without this, viewDidLoad never triggers

      // then
      XCTAssertEqual(2, received.count, "Should only receives one Value")
      XCTAssertEqual(expected, received, "AiringTodayViewModel should contains loading State")
    }
  }

  func test_when_useCase_respons_with_FirstPage_ViewModel_Should_contains_Paging_State() async {
    await withMainSerialExecutor {
      // given
      fetchUseCaseMock.result = buildFirstPage()
      let firstPageCells = buildFirstPage().showsList.map { AiringTodayCollectionViewModel(show: $0) }

      let sut: AiringTodayViewModelProtocol =
      AiringTodayViewModel(fetchTVShowsUseCase: { self.fetchUseCaseMock }, coordinator: nil)

      let expected: [SimpleViewState<AiringTodayCollectionViewModel>] = [
        .loading, .loading,
        .paging(firstPageCells, next: 2)
      ]
      var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

      sut.viewStateObservableSubject
        .sink(receiveValue: { received.append($0) }).store(in: &self.disposeBag)

      // when
      let task = Task { await sut.viewDidLoad() }
      await Task.yield() /// will trigger viewDidLoad

      XCTAssertEqual(2, received.count, "Should contains 2 values")

      await task.value

      // then
      XCTAssertEqual(3, received.count, "Should contains 3 values")
      expectNoDifference(expected, received, "AiringTodayViewModel Should contains 2 values")
    }
  }

  func test_When_ask_for_second_page_ViewModel_Should_contains_Populated_State_with_Second_Page() async {
    await withMainSerialExecutor {
      // given
      let sut: AiringTodayViewModelProtocol
      sut = AiringTodayViewModel(fetchTVShowsUseCase: { self.fetchUseCaseMock }, coordinator: nil)

      let firstPage = buildFirstPage().showsList.map { AiringTodayCollectionViewModel(show: $0) }
      let secondPage = (buildFirstPage().showsList + buildSecondPage().showsList).map { AiringTodayCollectionViewModel(show: $0) }

      let expected: [SimpleViewState<AiringTodayCollectionViewModel>] = [
        .loading,
        .loading,
        .paging(firstPage, next: 2),
        .populated(secondPage)
      ]
      var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

      sut.viewStateObservableSubject
        .sink(receiveValue: { received.append($0) }).store(in: &self.disposeBag)

      // when
      fetchUseCaseMock.result = buildFirstPage()
      await sut.viewDidLoad()

      // and
      fetchUseCaseMock.result = buildSecondPage()
      let totalShows = buildFirstPage().showsList.count + buildSecondPage().showsList.count
      let task = Task { await sut.willDisplayRow(totalShows - 1, outOf: totalShows) }
      await task.value

      // then
      expectNoDifference(expected, received, "Should contains 3 values")
    }
  }

  func test_When_UseCase_Responds_Error_ViewModel_Should_Contains_Error_State() async {
    await withMainSerialExecutor {
      // given
      fetchUseCaseMock.error = ApiError(error: NSError(domain: "", code: 0, userInfo: nil))
      let sut: AiringTodayViewModelProtocol
      sut = AiringTodayViewModel(fetchTVShowsUseCase:  { self.fetchUseCaseMock }, coordinator: nil)

      let expected : [SimpleViewState<AiringTodayCollectionViewModel>] = [
        .loading, .loading,
        .error("")
      ]
      var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

      sut.viewStateObservableSubject
        .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

      // when
      await sut.viewDidLoad()

      // then
      XCTAssertEqual(expected, received, "AiringTodayViewModel should contains Error State")
    }
  }

  func test_When_UseCase_Responds_With_Zero_Elements_ViewModel_Should_Contains_Empty_State() async {
    await withMainSerialExecutor {
      // given
      fetchUseCaseMock.result = .empty
      let sut: AiringTodayViewModelProtocol
      sut = AiringTodayViewModel(fetchTVShowsUseCase: { self.fetchUseCaseMock }, coordinator: nil)

      let expected: [SimpleViewState<AiringTodayCollectionViewModel>] = [
        .loading, .loading, .empty
      ]
      var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

      sut.viewStateObservableSubject
        .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

      // when
      await sut.viewDidLoad()

      // then
      XCTAssertEqual(expected, received, "AiringTodayViewModel should contains Empty State")
    }
  }

  func test_When_UseCase_Responds_Error_And_User_Retry_ViewModel_Should_Contains_Paginated_State() async {
    await withMainSerialExecutor {
      // given
      fetchUseCaseMock.error = ApiError(error: NSError(domain: "", code: 0, userInfo: nil))
      let sut: AiringTodayViewModelProtocol
      sut = AiringTodayViewModel(fetchTVShowsUseCase: { self.fetchUseCaseMock }, coordinator: nil)

      let expected: [SimpleViewState<AiringTodayCollectionViewModel>] = [
        .loading, .loading, .error(""),
        .paging(buildFirstPage().showsList.map { AiringTodayCollectionViewModel(show: $0) }, next: 2)
      ]
      var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

      sut.viewStateObservableSubject
        .print("🚨")
        .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

      // when
      await sut.viewDidLoad()

      // and
      fetchUseCaseMock.result = buildFirstPage()
      fetchUseCaseMock.error = nil
      await sut.refreshView()

      // then
      XCTAssertEqual(expected, received, "AiringTodayViewModel should contains Paginated State")
    }
  }

  func test_Jump_from_States_Paginated_Error_Populated() async {
    await withMainSerialExecutor {
      // given
      let firstPage = buildFirstPage()
      let secondPage = buildSecondPage()

      let firstPageVM = firstPage.showsList.map { AiringTodayCollectionViewModel(show: $0) }
      let secondPageVM = (firstPage.showsList + secondPage.showsList).map { AiringTodayCollectionViewModel(show: $0) }

      let sut: AiringTodayViewModelProtocol
      sut = AiringTodayViewModel(fetchTVShowsUseCase: { self.fetchUseCaseMock }, coordinator: nil)

      let expected: [SimpleViewState<AiringTodayCollectionViewModel>] = [
        .loading, .loading,
        .paging(firstPageVM, next: 2),
        .populated(secondPageVM)
      ]
      var received = [SimpleViewState<AiringTodayCollectionViewModel>]()

      sut.viewStateObservableSubject
        .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

      // when
      fetchUseCaseMock.result = firstPage
      await sut.viewDidLoad()

      // and
      fetchUseCaseMock.result = nil
      fetchUseCaseMock.error = ApiError(error: NSError(domain: "", code: 0, userInfo: nil))
      await sut.willDisplayRow(firstPage.showsList.count - 1, outOf: firstPage.showsList.count)

      // again
      fetchUseCaseMock.result = secondPage
      fetchUseCaseMock.error = nil
      let totalShows = firstPage.showsList.count + secondPage.showsList.count
      await sut.willDisplayRow(totalShows - 1, outOf: totalShows)

      // then
      expectNoDifference(expected, received, "AiringTodayViewModel should contains Paginated State")
    }
  }
}
