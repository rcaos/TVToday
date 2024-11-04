//
//  Created by Jeans Ruiz on 8/5/20.
//

import Combine
import XCTest
import NetworkingInterface

@testable import ShowDetailsFeature
@testable import Shared

class FavoriteTapsTests: XCTestCase {

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

  func test_Taps_Happy_Path() async {
    // given
    let initialFavoriteState = false
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchTVAccountStateMock.result = TVShowAccountStatus.stub(showId: 1, isFavorite: initialFavoriteState, isWatchList: false)

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
    sut.isFavorite.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    await sut.viewDidLoad()
//    scheduler.advance(by: 1)
    XCTAssertEqual([false], received)

    // 1. First Tap, Returns OK
    markAsFavoriteUseCaseMock.result = true
    markAsFavoriteUseCaseMock.error = nil
    sut.favoriteButtonDidTapped()
    //scheduler.advance(by: .milliseconds(300))
    XCTAssertEqual(1, markAsFavoriteUseCaseMock.calledCounter)
    XCTAssertEqual([false, true], received)

    // 2. Second Tap, Returns OK
    sut.favoriteButtonDidTapped()
    markAsFavoriteUseCaseMock.result = false
    markAsFavoriteUseCaseMock.error = nil
//    scheduler.advance(by: .milliseconds(300))
    XCTAssertEqual(2, markAsFavoriteUseCaseMock.calledCounter)
    XCTAssertEqual([false, true, false], received)

    // 3. Third Tap, Returns Error
    markAsFavoriteUseCaseMock.result = nil
    markAsFavoriteUseCaseMock.error = ApiError(error: NSError(domain: "Mock", code: 0, userInfo: nil))
    sut.favoriteButtonDidTapped()
//    scheduler.advance(by: .milliseconds(300))
    XCTAssertEqual(3, markAsFavoriteUseCaseMock.calledCounter)
    XCTAssertEqual([false, true, false], received)

    // 4. Fourth Tap, Returns OK
    markAsFavoriteUseCaseMock.result = true
    markAsFavoriteUseCaseMock.error = nil
    sut.favoriteButtonDidTapped()
//    scheduler.advance(by: .milliseconds(300))
    XCTAssertEqual(4, markAsFavoriteUseCaseMock.calledCounter)
    XCTAssertEqual([false, true, false, true], received)
  }

  func test_Request_is_On_Flight() async {
    // given
    let initialFavoriteState = true
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchTVAccountStateMock.result = TVShowAccountStatus.stub(showId: 1, isFavorite: initialFavoriteState, isWatchList: false)

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
    sut.isFavorite.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    await sut.viewDidLoad()
//    scheduler.advance(by: 1)
    XCTAssertEqual([false, true], received)

    // 1. First Tap
    sut.favoriteButtonDidTapped()

    // UseCase does not respond yet
    markAsFavoriteUseCaseMock.result = nil
    markAsFavoriteUseCaseMock.error = nil

//    scheduler.advance(by: .milliseconds(300))
    XCTAssertEqual(1, markAsFavoriteUseCaseMock.calledCounter)
    XCTAssertEqual([false, true], received)

    // 2. Second Tap, but The First request is on flight
    sut.favoriteButtonDidTapped()
//    scheduler.advance(by: .milliseconds(300))

    XCTAssertEqual(1, markAsFavoriteUseCaseMock.calledCounter, "Last request is on Flight")
    XCTAssertEqual([false, true], received)

    // 3. The First request Responds
//    markAsFavoriteUseCaseMock.subject.send(false) // todo, send new value
//    scheduler.advance(by: .nanoseconds(1))
    XCTAssertEqual([false, true, false], received)

    // 3. Third Tap
    sut.favoriteButtonDidTapped()
    markAsFavoriteUseCaseMock.result = true
    markAsFavoriteUseCaseMock.error = nil
//    scheduler.advance(by: .milliseconds(300))

    XCTAssertEqual(2, markAsFavoriteUseCaseMock.calledCounter)
    XCTAssertEqual([false, true, false, true], received)
  }
}
