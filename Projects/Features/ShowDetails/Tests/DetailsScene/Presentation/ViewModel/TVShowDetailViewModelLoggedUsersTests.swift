//
//  TVShowDetailViewModelLoggedUsersTests.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/4/20.
//

import Combine
import XCTest
@testable import ShowDetails
@testable import Shared

class TVShowDetailViewModelLoggedUsersTests: XCTestCase {

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

  func test_For_Logged_User_When_UseCase_Doesnot_Respond_Yet_ViewModel_Should_Contains_Loading_State() {
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

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.01)

    // then
    XCTAssertEqual(expected, received, "Should contains loading State")
  }

  func test_For_Logged_User_When_UseCase_Respond_OK_ViewModel_Should_Contains_Populated_State() {
    // given
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: true, isWatchList: true)

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

    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.01)

    // then
    XCTAssertEqual(expected, received, "Should contains loading State")
  }

  func test_For_Logged_User_When_ShowDetails_UseCase_Respond_Error_ViewModel_Should_Contains_Error_State() {
    // given
    fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: true, isWatchList: true)
    fetchTVShowDetailsUseCaseMock.error = .noResponse

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

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.01)

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
      coordinator: nil
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

    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.01)

    // then
    XCTAssertEqual(expected, received, "Should contains Error State")
  }

  // MARK: - TODO, look the way of thest this case
//  func test_For_Logged_When_Error_Happens_And_Did_Refresh_ViewModel_Should_Contains_Populated() {
//    // given
//    fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: true, isWatchList: true)
//    fetchTVShowDetailsUseCaseMock.error = .noResponse
//
//    // let viewStateObserver = scheduler.createObserver(TVShowDetailViewModel.ViewState.self)
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
//      TVShowDetailViewModel.ViewState.populated(TVShowDetailInfo(show: detailResult))
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
//    //          viewModel.viewState
//    //            .subscribe { event in
//    //              viewStateObserver.on(event)
//    //            }
//    //            .disposed(by: disposeBag)
//    //
//
//    // when
//    sut.viewDidLoad()
//    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.01)
//
//    fetchTVShowDetailsUseCaseMock.error = nil
//    fetchTVShowDetailsUseCaseMock.result = self.detailResult
//    sut.refreshView()
//    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.01)
//
//    // then
//    XCTAssertEqual(expected, received, "Should contains Populated State")
//  }

  func test_For_Logged_When_Usecase_get_Favorite_State_ViewModel_Should_Contains_isFavorite_Value() {
    // given
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: true, isWatchList: true)

    let sut: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
      1,
      fetchLoggedUser: fetchLoggedUserMock,
      fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
      fetchTvShowState: fetchTVAccountStateMock,
      markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
      saveToWatchListUseCase: saveToWatchListUseCaseMock,
      coordinator: nil
    )

    let expected = [false, true]
    var received = [Bool]()

    sut.isFavorite
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.01)

    // then
    XCTAssertEqual(expected, received, "Should contains Favorite State")
  }

  func test_For_Logged_When_Usecase_get_Favorite_State_ViewModel_Should_Contains_isFavorite_False_Value() {
    // given
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: false, isWatchList: true)

    let sut: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
      1,
      fetchLoggedUser: fetchLoggedUserMock,
      fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
      fetchTvShowState: fetchTVAccountStateMock,
      markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
      saveToWatchListUseCase: saveToWatchListUseCaseMock,
      coordinator: nil
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

    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.01)

    // then
    XCTAssertEqual(expected, received, "Should contains Favorite State to false")
  }

  func test_For_Logged_When_Usecase_get_WatchList_State_ViewModel_Should_Contains_isFavorite_Value() {
    // given
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: true, isWatchList: true)

    let sut: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
      1,
      fetchLoggedUser: fetchLoggedUserMock,
      fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
      fetchTvShowState: fetchTVAccountStateMock,
      markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
      saveToWatchListUseCase: saveToWatchListUseCaseMock,
      coordinator: nil
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

    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.01)

    // then
    XCTAssertEqual(expected, received, "Should contains Favorite State")
  }
}
//      context("When Account Use Case State Retrieves isWatchList State") {
//        it("Should ViewModel isWatchList contains False") {
//          // given
//          let isInitialWatchList = false
//
//          fetchTVShowDetailsUseCaseMock.result = self.detailResult
//          fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: true, isWatchList: isInitialWatchList)
//
//          let viewModel: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
//            1,
//            fetchLoggedUser: fetchLoggedUserMock,
//            fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
//            fetchTvShowState: fetchTVAccountStateMock,
//            markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
//            saveToWatchListUseCase: saveToWatchListUseCaseMock,
//            coordinator: nil
//          )
//
//          // when
//          viewModel.viewDidLoad()
//
//          // then
//          let isWatchListSubject = try? viewModel.isWatchList.toBlocking(timeout: 2).first()
//          guard let isWatchListObserver = isWatchListSubject else {
//            fail("It should emit a View State")
//            return
//          }
//
//          expect(isWatchListObserver).toEventually(equal(isInitialWatchList))
//        }
//      }
//    }
//  }
//}
