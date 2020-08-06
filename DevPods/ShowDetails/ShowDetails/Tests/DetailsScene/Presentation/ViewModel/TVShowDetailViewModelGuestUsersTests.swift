//
//  TVShowDetailViewModelTests.swift
//  TVShowDetailViewModelTests-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

import Quick
import Nimble
import RxSwift
import RxBlocking
import RxTest

@testable import ShowDetails
@testable import Shared

class TVShowDetailViewModelGuestUsersTests: QuickSpec {
  
  let detailResult = TVShowDetailResult.stub()
  
  override func spec() {
    describe("TVShowDetailViewModel for Guest Users") {
      var fetchLoggedUserMock: FetchLoggedUserMock!
      var fetchTVShowDetailsUseCaseMock: FetchTVShowDetailsUseCaseMock!
      var fetchTVAccountStateMock: FetchTVAccountStateMock!
      var markAsFavoriteUseCaseMock: MarkAsFavoriteUseCaseMock!
      var saveToWatchListUseCaseMock: SaveToWatchListUseCaseMock!
      
      beforeEach {
        fetchLoggedUserMock = FetchLoggedUserMock()
        fetchTVShowDetailsUseCaseMock = FetchTVShowDetailsUseCaseMock()
        fetchTVAccountStateMock = FetchTVAccountStateMock()
        markAsFavoriteUseCaseMock = MarkAsFavoriteUseCaseMock()
        saveToWatchListUseCaseMock = SaveToWatchListUseCaseMock()
      }
      
      context("When waiting for response of Fetch Use Case") {
        it("Should ViewModel contanins Loading State") {
          // given
          // not response yet
          
          let viewModel: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
            1,
            fetchLoggedUser: fetchLoggedUserMock,
            fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
            fetchTvShowState: fetchTVAccountStateMock,
            markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
            saveToWatchListUseCase: saveToWatchListUseCaseMock,
            coordinator: nil
          )
          
          // when
          viewModel.viewDidLoad()
          
          // when
          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected = TVShowDetailViewModel.ViewState.loading
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
      
      context("When User Fetch Use Case Retrieve Show Details") {
        it("Should ViewModel contains the Details of TVShow") {
          // given
          let showDetails = TVShowDetailInfo(show: self.detailResult)
          
          fetchTVShowDetailsUseCaseMock.result = self.detailResult
          
          let viewModel: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
            1,
            fetchLoggedUser: fetchLoggedUserMock,
            fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
            fetchTvShowState: fetchTVAccountStateMock,
            markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
            saveToWatchListUseCase: saveToWatchListUseCaseMock,
            coordinator: nil
          )
          
          // when
          viewModel.viewDidLoad()
          
          // then
          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected = TVShowDetailViewModel.ViewState.populated(showDetails)
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
      
      context("When Fetch Use Case Retrieve Error") {
        it("Should ViewModel contains Error State") {
          // given
          
          fetchTVShowDetailsUseCaseMock.error = CustomError.genericError
          
          let viewModel: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
            1,
            fetchLoggedUser: fetchLoggedUserMock,
            fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
            fetchTvShowState: fetchTVAccountStateMock,
            markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
            saveToWatchListUseCase: saveToWatchListUseCaseMock,
            coordinator: nil
          )
          
          // when
          viewModel.viewDidLoad()
          
          // then
          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected = TVShowDetailViewModel.ViewState.error("")
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
      
      context("When Error Happens and did RefreshView") {
        it("Should ViewModel contains Details of TV Show") {
          // given
          fetchTVShowDetailsUseCaseMock.error = CustomError.genericError
          
          let scheduler = TestScheduler(initialClock: 0)
          let disposeBag = DisposeBag()
          let viewStateObserver = scheduler.createObserver(TVShowDetailViewModel.ViewState.self)
          
          let viewModel: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
            1,
            fetchLoggedUser: fetchLoggedUserMock,
            fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
            fetchTvShowState: fetchTVAccountStateMock,
            markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
            saveToWatchListUseCase: saveToWatchListUseCaseMock,
            coordinator: nil
          )
          
          viewModel.viewState
            .bind(to: viewStateObserver)
            .disposed(by: disposeBag)
          
          // when
          viewModel.viewDidLoad()
          
          fetchTVShowDetailsUseCaseMock.error = nil
          fetchTVShowDetailsUseCaseMock.result = self.detailResult
          viewModel.refreshView()
          
          // then
          let populatedState = TVShowDetailViewModel.ViewState.populated(TVShowDetailInfo(show: self.detailResult))
          
          let expectedStates: [Recorded<Event<TVShowDetailViewModel.ViewState>>] =
            [ .next(0, .loading),
              .next(0, .error("")) ,
              .next(0, populatedState) ]
          
          expect(viewStateObserver.events).toEventually(equal(expectedStates))
        }
      }
    }
  }
}
