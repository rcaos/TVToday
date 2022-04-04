//
//  TVShowDetailViewModelTapsTests.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/5/20.
//

import Combine
import CombineSchedulers
import XCTest

@testable import ShowDetails
@testable import Shared

class TVShowDetailViewModelTapsTests: XCTestCase {

  let detailResult = TVShowDetailResult.stub()

  var fetchLoggedUserMock: FetchLoggedUserMock!
  var fetchTVShowDetailsUseCaseMock: FetchTVShowDetailsUseCaseMock!
  var fetchTVAccountStateMock: FetchTVAccountStateMock!
  var markAsFavoriteUseCaseMock: MarkAsFavoriteUseCaseMock!
  var saveToWatchListUseCaseMock: SaveToWatchListUseCaseMock!

  private var disposeBag: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    fetchLoggedUserMock = FetchLoggedUserMock()
    fetchLoggedUserMock.account = AccountDomain.stub(id: 1, sessionId: "")

    fetchTVShowDetailsUseCaseMock = FetchTVShowDetailsUseCaseMock()
    fetchTVAccountStateMock = FetchTVAccountStateMock()
    markAsFavoriteUseCaseMock = MarkAsFavoriteUseCaseMock()
    saveToWatchListUseCaseMock = SaveToWatchListUseCaseMock()
    disposeBag = []
  }

  func test_When_ViewModel_Receive_isFavorite_Tap_Observable_Should_Change() {
    // given
    let initialFavoriteState = true

    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: initialFavoriteState, isWatchList: false)

    let scheduler = DispatchQueue.test
    markAsFavoriteUseCaseMock.result = !initialFavoriteState

    let sut: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
      1,
      fetchLoggedUser: fetchLoggedUserMock,
      fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
      fetchTvShowState: fetchTVAccountStateMock,
      markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
      saveToWatchListUseCase: saveToWatchListUseCaseMock,
      coordinator: nil,
      scheduler: scheduler.eraseToAnyScheduler()
    )

    let expected = [false, initialFavoriteState, !initialFavoriteState]
    var received = [Bool]()

    sut.isFavorite.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.viewDidLoad()
    scheduler.advance(by: 1)

    sut.favoriteButtonDidTapped()
    scheduler.advance(by: .milliseconds(300))

    // then
    XCTAssertEqual(expected, received, "Should contains Populated State")
  }

  func test_When_ViewModel_Receive_isWatched_Tap_Observable_Should_Change() {
//    // given
//    let initialStateWatched = false
//
//    fetchTVShowDetailsUseCaseMock.result = self.detailResult
//    fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: true, isWatchList: initialStateWatched)
//
//    let scheduler = TestScheduler(initialClock: 0)
//    let disposeBag = DisposeBag()
//    let watchedObserver = scheduler.createObserver(Bool.self)
//
//    saveToWatchListUseCaseMock.result = !initialStateWatched
//
//    let viewModel: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
//      1,
//      fetchLoggedUser: fetchLoggedUserMock,
//      fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
//      fetchTvShowState: fetchTVAccountStateMock,
//      markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
//      saveToWatchListUseCase: saveToWatchListUseCaseMock,
//      coordinator: nil
//    )
//
//    viewModel.isWatchList
//      .subscribe { event in
//        watchedObserver.on(event)
//      }
//      .disposed(by: disposeBag)
//
//    // when
//    viewModel.viewDidLoad()
//
//    // Emit taps from View
//    scheduler.createColdObservable([.next(10, ())])
//      .subscribe { event in
//        viewModel.tapWatchedButton.on(event)
//      }
//      .disposed(by: disposeBag)
//    scheduler.start()
//
//    // then
//    let expected: [Recorded<Event<Bool>>] =
//    [.next(0, false),
//     .next(0, initialStateWatched),
//     .next(10, !initialStateWatched)]
//
//    expect(watchedObserver.events)
//      .toEventually(equal(expected), timeout: .milliseconds(500))
  }
}
