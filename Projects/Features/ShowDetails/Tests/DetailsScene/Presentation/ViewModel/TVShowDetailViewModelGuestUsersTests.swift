//
//  TVShowDetailViewModelTests.swift
//  TVShowDetailViewModelTests-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

import Combine
import XCTest
@testable import ShowDetails
@testable import Shared

class TVShowDetailViewModelGuestUsersTests: XCTestCase {

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
    fetchTVShowDetailsUseCaseMock = FetchTVShowDetailsUseCaseMock()
    fetchTVAccountStateMock = FetchTVAccountStateMock()
    markAsFavoriteUseCaseMock = MarkAsFavoriteUseCaseMock()
    saveToWatchListUseCaseMock = SaveToWatchListUseCaseMock()
    disposeBag = []
  }

  func test_For_Guest_User_When_UseCase_Doesnot_Respond_Yet_ViewModel_Should_Contains_Loading_State() {
    // given
    let sut: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
      1,
      fetchLoggedUser: fetchLoggedUserMock,
      fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
      fetchTvShowState: fetchTVAccountStateMock,
      markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
      saveToWatchListUseCase: saveToWatchListUseCaseMock,
      coordinator: nil,
      scheduler: .immediate
    )

    let expected = [TVShowDetailViewModel.ViewState.loading]
    var received = [TVShowDetailViewModel.ViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains loading State")
  }

  func test_For_Guest_User_When_UseCase_Respons_OK_ViewModel_Should_Contains_Detiails_Of_Show() {
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
      coordinator: nil,
      scheduler: .immediate
    )

    let expected = [
      TVShowDetailViewModel.ViewState.loading,
      TVShowDetailViewModel.ViewState.populated(showDetails)
    ]
    var received = [TVShowDetailViewModel.ViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains loading State")
  }

  func test_For_Guest_User_When_UseCase_Respons_Error_ViewModel_Should_Contains_Error_State() {
    // given
    fetchTVShowDetailsUseCaseMock.error = .noResponse

    let sut: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
      1,
      fetchLoggedUser: fetchLoggedUserMock,
      fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
      fetchTvShowState: fetchTVAccountStateMock,
      markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
      saveToWatchListUseCase: saveToWatchListUseCaseMock,
      coordinator: nil,
      scheduler: .immediate
    )

    let expected = [
      TVShowDetailViewModel.ViewState.loading,
      TVShowDetailViewModel.ViewState.error("")
    ]
    var received = [TVShowDetailViewModel.ViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains loading State")
  }

  // MARK: - TODO, test this case, Handle the Scheduler
//  func test_For_Guest_User_When_Error_Happens_And_Refresh_View_Should_Contains_Details_Of_Show() {
//    // given
//    fetchTVShowDetailsUseCaseMock.error = .noResponse
//
//    let sut: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
//      1,
//      fetchLoggedUser: fetchLoggedUserMock,
//      fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
//      fetchTvShowState: fetchTVAccountStateMock,
//      markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
//      saveToWatchListUseCase: saveToWatchListUseCaseMock,
//      coordinator: nil
//    )
//
//    let expected = [
//      TVShowDetailViewModel.ViewState.loading,
//      TVShowDetailViewModel.ViewState.error(""),
//      TVShowDetailViewModel.ViewState.populated(TVShowDetailInfo(show: self.detailResult))
//    ]
//    var received = [TVShowDetailViewModel.ViewState]()
//
//    sut.viewState
//      .removeDuplicates()
//      .sink(receiveValue: { value in
//        received.append(value)
//      })
//      .store(in: &disposeBag)
//
//    // when
//    sut.viewDidLoad()
//    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
//
//    fetchTVShowDetailsUseCaseMock.error = nil
//    fetchTVShowDetailsUseCaseMock.result = self.detailResult
//
//    // And when
//    sut.refreshView()
//    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
//
//    // then
//    XCTAssertEqual(expected, received, "Should contains Populated State")
//  }
}
