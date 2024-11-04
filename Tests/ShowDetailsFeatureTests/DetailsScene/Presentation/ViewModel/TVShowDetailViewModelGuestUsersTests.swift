//
//  Created by Jeans Ruiz on 7/28/20.
//

import Combine
import XCTest
@testable import ShowDetailsFeature
@testable import Shared
import NetworkingInterface

class TVShowDetailViewModelGuestUsersTests: XCTestCase {

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
    fetchTVShowDetailsUseCaseMock = FetchTVShowDetailsUseCaseMock()
    fetchTVAccountStateMock = FetchTVAccountStateMock()
    markAsFavoriteUseCaseMock = MarkAsFavoriteUseCaseMock()
    saveToWatchListUseCaseMock = SaveToWatchListUseCaseMock()
    disposeBag = []
  }

  func test_For_Guest_User_When_UseCase_Doesnot_Respond_Yet_ViewModel_Should_Contains_Loading_State() async {
    // given
    let sut: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
      1,
      fetchLoggedUser: fetchLoggedUserMock,
      fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
      fetchTvShowState: fetchTVAccountStateMock,
      markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
      saveToWatchListUseCase: saveToWatchListUseCaseMock,
      coordinator: nil
    )

    let expected = [TVShowDetailViewModel.ViewState.loading]
    var received = [TVShowDetailViewModel.ViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    await sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains loading State")
  }

  func test_For_Guest_User_When_UseCase_Respons_OK_ViewModel_Should_Contains_Detiails_Of_Show() async {
    // given
    let showDetails = TVShowDetailInfo(show: self.detailResult)
    fetchTVShowDetailsUseCaseMock.result = self.detailResult

    let sut: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
      1,
      fetchLoggedUser: fetchLoggedUserMock,
      fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
      fetchTvShowState: fetchTVAccountStateMock,
      markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
      saveToWatchListUseCase: saveToWatchListUseCaseMock,
      coordinator: nil
    )

    let expected = [
      TVShowDetailViewModel.ViewState.loading,
      TVShowDetailViewModel.ViewState.populated(showDetails)
    ]
    var received = [TVShowDetailViewModel.ViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    await sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains loading State")
  }

  func test_For_Guest_User_When_UseCase_Respons_Error_ViewModel_Should_Contains_Error_State() async {
    // given
    fetchTVShowDetailsUseCaseMock.error = ApiError(error: NSError(domain: "Mock", code: 0, userInfo: nil))

    let sut: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
      1,
      fetchLoggedUser: fetchLoggedUserMock,
      fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
      fetchTvShowState: fetchTVAccountStateMock,
      markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
      saveToWatchListUseCase: saveToWatchListUseCaseMock,
      coordinator: nil
    )

    let expected = [
      TVShowDetailViewModel.ViewState.loading,
      TVShowDetailViewModel.ViewState.error("")
    ]
    var received = [TVShowDetailViewModel.ViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    await sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains loading State")
  }

  func test_For_Guest_User_When_Error_Happens_And_Refresh_View_Should_Contains_Details_Of_Show() async {

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

    let expected = [
      TVShowDetailViewModel.ViewState.loading,
      TVShowDetailViewModel.ViewState.error(""),
      TVShowDetailViewModel.ViewState.populated(TVShowDetailInfo(show: self.detailResult))
    ]
    var received = [TVShowDetailViewModel.ViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) })
      .store(in: &disposeBag)

    // given
    // 1. First attempt responds with Error
    fetchTVShowDetailsUseCaseMock.error = ApiError(error: NSError(domain: "Mock", code: 0, userInfo: nil))

    // when
    await sut.viewDidLoad()
//    scheduler.advance(by: 1)

    // 2. second attempt responds Successfully
    fetchTVShowDetailsUseCaseMock.error = nil
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    // And when Retry
    await sut.refreshView()
//    scheduler.advance(by: 1)

    // then
    XCTAssertEqual(expected, received, "Should contains Populated State")
  }
}
