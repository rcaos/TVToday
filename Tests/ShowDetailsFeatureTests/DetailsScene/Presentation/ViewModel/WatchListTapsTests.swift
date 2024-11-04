//
//  Created by Jeans Ruiz on 5/04/22.
//

import Combine
import XCTest
import NetworkingInterface

@testable import ShowDetailsFeature
@testable import Shared

#warning("recover these tests")
class WatchListTapsTests: XCTestCase {

  let detailResult = TVShowDetail.stub()

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

  func test_WatchList_Taps_Happy_Path() async {
    // given
    let initialWatchListState = false
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchTVAccountStateMock.result = TVShowAccountStatus.stub(showId: 1, isFavorite: false, isWatchList: initialWatchListState)

//    let scheduler = DispatchQueue.test

    let sut: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
      1,
      fetchLoggedUser: fetchLoggedUserMock,
      fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
      fetchTvShowState: fetchTVAccountStateMock,
      markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
      saveToWatchListUseCase: saveToWatchListUseCaseMock,
      coordinator: nil
    )

    var received = [Bool]()
    sut.isWatchList.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    await sut.viewDidLoad()
//    scheduler.advance(by: 1)
    XCTAssertEqual([false], received)

    // 1. First Tap, Returns OK
    saveToWatchListUseCaseMock.result = true
    saveToWatchListUseCaseMock.error = nil
    sut.watchedButtonDidTapped()
//    scheduler.advance(by: .milliseconds(300))
    XCTAssertEqual(1, saveToWatchListUseCaseMock.calledCounter)
    XCTAssertEqual([false, true], received)

    // 2. Second Tap, Returns OK
    sut.watchedButtonDidTapped()
    saveToWatchListUseCaseMock.result = false
    saveToWatchListUseCaseMock.error = nil
//    scheduler.advance(by: .milliseconds(300))
    XCTAssertEqual(2, saveToWatchListUseCaseMock.calledCounter)
    XCTAssertEqual([false, true, false], received)

    // 3. Third Tap, Returns Error
    saveToWatchListUseCaseMock.result = nil
    saveToWatchListUseCaseMock.error = ApiError(error: NSError(domain: "Mock", code: 0, userInfo: nil))
    sut.watchedButtonDidTapped()
//    scheduler.advance(by: .milliseconds(300))
    XCTAssertEqual(3, saveToWatchListUseCaseMock.calledCounter)
    XCTAssertEqual([false, true, false], received)

    // 4. Fourth Tap, Returns OK
    saveToWatchListUseCaseMock.result = true
    saveToWatchListUseCaseMock.error = nil
    sut.watchedButtonDidTapped()
//    scheduler.advance(by: .milliseconds(300))
    XCTAssertEqual(4, saveToWatchListUseCaseMock.calledCounter)
    XCTAssertEqual([false, true, false, true], received)
  }

  func test_WatchList_Request_is_On_Flight() async {
    // given
    let initialWatchListState = true
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchTVAccountStateMock.result = TVShowAccountStatus.stub(showId: 1, isFavorite: false, isWatchList: initialWatchListState)

//    let scheduler = DispatchQueue.test

    let sut: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
      1,
      fetchLoggedUser: fetchLoggedUserMock,
      fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
      fetchTvShowState: fetchTVAccountStateMock,
      markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
      saveToWatchListUseCase: saveToWatchListUseCaseMock,
      coordinator: nil
    )

    var received = [Bool]()
    sut.isWatchList.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    await sut.viewDidLoad()
//    scheduler.advance(by: 1)
    XCTAssertEqual([false, true], received)

    // 1. First Tap
    sut.watchedButtonDidTapped()

    // UseCase does not respond yet
    saveToWatchListUseCaseMock.result = nil
    saveToWatchListUseCaseMock.error = nil

//    scheduler.advance(by: .milliseconds(300))
    XCTAssertEqual(1, saveToWatchListUseCaseMock.calledCounter)
    XCTAssertEqual([false, true], received)

    // 2. Second Tap, but The First request is on flight
    sut.watchedButtonDidTapped()
//    scheduler.advance(by: .milliseconds(300))

    XCTAssertEqual(1, saveToWatchListUseCaseMock.calledCounter, "Last request is on Flight")
    XCTAssertEqual([false, true], received)

    // 3. The First request Responds
//    saveToWatchListUseCaseMock.subject.send(false) // todo, send new value
//    scheduler.advance(by: .nanoseconds(1))
    XCTAssertEqual([false, true, false], received)

    // 3. Third Tap
    sut.watchedButtonDidTapped()
    saveToWatchListUseCaseMock.result = true
    saveToWatchListUseCaseMock.error = nil
//    scheduler.advance(by: .milliseconds(300))

    XCTAssertEqual(2, saveToWatchListUseCaseMock.calledCounter)
    XCTAssertEqual([false, true, false, true], received)
  }
}
