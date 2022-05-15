//
//  TVShowDetailViewModelLoggedUsersTests.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/4/20.
//

import Combine
import XCTest
@testable import ShowDetailsFeature
@testable import Shared

class TVShowDetailViewModelLoggedUsersTests: XCTestCase {

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

  func test_For_Logged_User_When_UseCase_Doesnot_Respond_Yet_ViewModel_Should_Contains_Loading_State() {
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

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains loading State")
  }

  func test_For_Logged_User_When_UseCase_Respond_OK_ViewModel_Should_Contains_Populated_State() {
    // given
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchTVAccountStateMock.result = TVShowAccountStatus.stub(showId: 1, isFavorite: true, isWatchList: true)

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
      TVShowDetailViewModel.ViewState.populated(TVShowDetailInfo(show: self.detailResult))
    ]
    var received = [TVShowDetailViewModel.ViewState]()

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains loading State")
  }

  func test_For_Logged_User_When_ShowDetails_UseCase_Respond_Error_ViewModel_Should_Contains_Error_State() {
    // given
    fetchTVAccountStateMock.result = TVShowAccountStatus.stub(showId: 1, isFavorite: true, isWatchList: true)
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

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains Error State")
  }

  func test_For_Logged_User_When_Account_UseCase_Respond_Error_ViewModel_Should_Contains_Error_State() {
    // given
    fetchTVAccountStateMock.error = .noResponse
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
      TVShowDetailViewModel.ViewState.error("")
    ]
    var received = [TVShowDetailViewModel.ViewState]()

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains Error State")
  }

  func test_For_Logged_When_Recovery_From_Error_to_Populated_State() {
    // given
    let scheduler = DispatchQueue.test

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

    let expected = [
      TVShowDetailViewModel.ViewState.loading,
      TVShowDetailViewModel.ViewState.error(""),
      TVShowDetailViewModel.ViewState.populated(TVShowDetailInfo(show: detailResult))
    ]
    var received = [TVShowDetailViewModel.ViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // First Attempt got error
    fetchTVAccountStateMock.result = TVShowAccountStatus.stub(showId: 1, isFavorite: true, isWatchList: true)
    fetchTVShowDetailsUseCaseMock.error = .noResponse

    // when
    sut.viewDidLoad()
    scheduler.advance(by: 1)

    // Second attempt return successfully
    fetchTVShowDetailsUseCaseMock.error = nil
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    sut.refreshView()
    scheduler.advance(by: 1)

    // then
    XCTAssertEqual(expected, received, "Should contains Populated State")
  }

  func test_For_Logged_When_Usecase_get_Favorite_State_ViewModel_Should_Contains_isFavorite_Value() {
    // given
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchTVAccountStateMock.result = TVShowAccountStatus.stub(showId: 1, isFavorite: true, isWatchList: true)

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

    let expected = [false, true]
    var received = [Bool]()

    sut.isFavorite
      .print()
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains Favorite State")
  }

  func test_For_Logged_When_Usecase_get_Favorite_State_ViewModel_Should_Contains_isFavorite_False_Value() {
    // given
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchTVAccountStateMock.result = TVShowAccountStatus.stub(showId: 1, isFavorite: false, isWatchList: true)

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

    let expected = [false]
    var received = [Bool]()

    sut.isFavorite
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains Favorite State to false")
  }

  func test_For_Logged_When_Usecase_get_WatchList_State_ViewModel_Should_Contains_isFavorite_Value() {
    // given
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchTVAccountStateMock.result = TVShowAccountStatus.stub(showId: 1, isFavorite: true, isWatchList: true)

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

    let expected = [false, true]
    var received = [Bool]()

    sut.isWatchList
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains Favorite State")
  }

  func test_For_Logged_When_Usecase_get_WatchList_State_ViewModel_Should_Contains_isFavorite_False_Value() {
    // given
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchTVAccountStateMock.result = TVShowAccountStatus.stub(showId: 1, isFavorite: true, isWatchList: false)

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

    let expected = [false]
    var received = [Bool]()

    sut.isWatchList
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains Favorite State to false")
  }
}
