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

//      context("When User Fetch Use Case Retrieve Show Details") {
//        it("Should ViewModel contains the Details of TVShow") {
//          // given
//          let showDetails = TVShowDetailInfo(show: self.detailResult)
//
//          fetchTVShowDetailsUseCaseMock.result = self.detailResult
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
//          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
//          guard let currentViewState = viewState else {
//            fail("It should emit a View State")
//            return
//          }
//          let expected = TVShowDetailViewModel.ViewState.populated(showDetails)
//
//          expect(currentViewState).toEventually(equal(expected))
//        }
//      }
//
//      context("When Fetch Use Case Retrieve Error") {
//        it("Should ViewModel contains Error State") {
//          // given
//
//          fetchTVShowDetailsUseCaseMock.error = CustomError.genericError
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
//          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
//          guard let currentViewState = viewState else {
//            fail("It should emit a View State")
//            return
//          }
//          let expected = TVShowDetailViewModel.ViewState.error("")
//
//          expect(currentViewState).toEventually(equal(expected))
//        }
//      }
//
//      context("When Error Happens and did RefreshView") {
//        it("Should ViewModel contains Details of TV Show") {
//          // given
//          fetchTVShowDetailsUseCaseMock.error = CustomError.genericError
//
//          let scheduler = TestScheduler(initialClock: 0)
//          let disposeBag = DisposeBag()
//          let viewStateObserver = scheduler.createObserver(TVShowDetailViewModel.ViewState.self)
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
//          viewModel.viewState
//            .subscribe { event in
//              viewStateObserver.on(event)
//            }
//            .disposed(by: disposeBag)
//
//          // when
//          viewModel.viewDidLoad()
//
//          fetchTVShowDetailsUseCaseMock.error = nil
//          fetchTVShowDetailsUseCaseMock.result = self.detailResult
//          viewModel.refreshView()
//
//          // then
//          let populatedState = TVShowDetailViewModel.ViewState.populated(TVShowDetailInfo(show: self.detailResult))
//
//          let expectedStates: [Recorded<Event<TVShowDetailViewModel.ViewState>>] =
//            [ .next(0, .loading),
//              .next(0, .error("")) ,
//              .next(0, populatedState) ]
//
//          expect(viewStateObserver.events).toEventually(equal(expectedStates))
//        }
//      }
//    }
//  }
}
