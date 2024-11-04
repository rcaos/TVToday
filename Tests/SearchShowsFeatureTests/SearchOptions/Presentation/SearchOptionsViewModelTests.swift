//
//  Created by Jeans Ruiz on 7/28/20.
//

import XCTest
import Combine
@testable import SearchShowsFeature
@testable import Persistence
@testable import Shared
import NetworkingInterface
import ConcurrencyExtras

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

  func test_When_UseCase_Doesnot_Responds_Yet_ViewModel_Should_Contains_Loading_State() async {
    await withMainSerialExecutor {
      // given
      sut = SearchOptionsViewModel(
        fetchGenresUseCase: fetchGenresUseCaseMock,
        fetchVisitedShowsUseCase: { self.fetchVisitedShowsUseCaseMock },
        recentVisitedShowsDidChange: { self.recentsDidChangeUseCaseMock }
      )

      // when
      let task = Task { await sut.viewDidLoad() }
      await Task.yield()

      var received = [SearchViewState]()
      sut.viewState.removeDuplicates()
        .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

      // then
      XCTAssertEqual([.loading], received)
    }
  }

  func test_when_useCase_Responds_Success_ViewModel_Should_contains_Populated_State() async {
    // given
    fetchGenresUseCaseMock.result = GenreList(genres: buildGenres())
              recentsDidChangeUseCaseMock.result = true
              fetchVisitedShowsUseCaseMock.result = buildShowVisited()

    sut = SearchOptionsViewModel(
      fetchGenresUseCase: fetchGenresUseCaseMock,
      fetchVisitedShowsUseCase: { self.fetchVisitedShowsUseCaseMock },
      recentVisitedShowsDidChange: { self.recentsDidChangeUseCaseMock }
    )

    var received = [SearchViewState]()
    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    await sut.viewDidLoad()

    // then
    XCTAssertEqual([.loading, .populated], received)
  }

  func test_when_useCase_Responds_With_Zero_Elements_ViewModel_Should_contains_Empty_State() async {
    // given
    fetchGenresUseCaseMock.result = GenreList(genres: [])
    recentsDidChangeUseCaseMock.result = true
    fetchVisitedShowsUseCaseMock.result = buildShowVisited()

    sut = SearchOptionsViewModel(
      fetchGenresUseCase: fetchGenresUseCaseMock,
      fetchVisitedShowsUseCase: { self.fetchVisitedShowsUseCaseMock },
      recentVisitedShowsDidChange: { self.recentsDidChangeUseCaseMock }
    )

    var received = [SearchViewState]()
    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    await sut.viewDidLoad()

    // then
    XCTAssertEqual([.loading, .empty], received)
  }

  func test_when_useCase_Responds_With_Error_ViewModel_Should_contains_Error_State() async {
    // given
    fetchGenresUseCaseMock.error = ApiError(error: NSError(domain: "", code: 0, userInfo: nil))
    recentsDidChangeUseCaseMock.result = true
    fetchVisitedShowsUseCaseMock.result = buildShowVisited()

    sut = SearchOptionsViewModel(
      fetchGenresUseCase: fetchGenresUseCaseMock,
      fetchVisitedShowsUseCase: { self.fetchVisitedShowsUseCaseMock },
      recentVisitedShowsDidChange: { self.recentsDidChangeUseCaseMock }
    )

    var received = [SearchViewState]()
    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    await sut.viewDidLoad()

    // MARK: - TODO, test recovery from error also

    // then
    XCTAssertEqual([.loading, .error("")], received, "Should contains 2 values")
  }
}
