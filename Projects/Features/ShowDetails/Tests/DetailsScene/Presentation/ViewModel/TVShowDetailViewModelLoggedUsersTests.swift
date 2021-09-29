//
//  TVShowDetailViewModelLoggedUsersTests.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/4/20.
//

import Quick
import Nimble
import RxSwift
import RxBlocking
import RxTest

@testable import ShowDetails
@testable import Shared

class TVShowDetailViewModelLoggedUsersTests: QuickSpec {
  
  let detailResult = TVShowDetailResult.stub()
  
  override func spec() {
    describe("TVShowDetailViewModel for Logged Users") {
      var fetchLoggedUserMock: FetchLoggedUserMock!
      var fetchTVShowDetailsUseCaseMock: FetchTVShowDetailsUseCaseMock!
      var fetchTVAccountStateMock: FetchTVAccountStateMock!
      var markAsFavoriteUseCaseMock: MarkAsFavoriteUseCaseMock!
      var saveToWatchListUseCaseMock: SaveToWatchListUseCaseMock!
      
      beforeEach {
        fetchLoggedUserMock = FetchLoggedUserMock()
        fetchLoggedUserMock.account = AccountDomain.stub(id: 1, sessionId: "")
        
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
          fetchTVShowDetailsUseCaseMock.result = self.detailResult
          fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: true, isWatchList: true)
          
          let showDetails = TVShowDetailInfo(show: self.detailResult)
          
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
      
      context("When Show Details Use Case Retrieve Error") {
        it("Should ViewModel contains Error State") {
          // given
          fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: true, isWatchList: true)
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
      
      context("When Account State Use Case Retrieve Error") {
        it("Should ViewModel contains Error State") {
          // given
          fetchTVAccountStateMock.error = CustomError.genericError
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
          let expected = TVShowDetailViewModel.ViewState.error("")
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
      
      context("When Error Happens and did RefreshView") {
        it("Should ViewModel contains Details of TVShow") {
          // given
          fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: true, isWatchList: true)
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
          let showDetails = TVShowDetailInfo(show: self.detailResult)
          let populatedState = TVShowDetailViewModel.ViewState.populated(showDetails)
          
          let expectedStates: [Recorded<Event<TVShowDetailViewModel.ViewState>>] =
            [ .next(0, .loading),
              .next(0, .error("")) ,
              .next(0, populatedState) ]
          
          expect(viewStateObserver.events).toEventually(equal(expectedStates))
        }
      }
      
      context("When Account Use Case State Retrieves isFavorite State") {
        it("Should ViewModel isFavorite contains True") {
          // given
          fetchTVShowDetailsUseCaseMock.result = self.detailResult
          fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: true, isWatchList: true)
          
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
          let isFavoriteSubject = try? viewModel.isFavorite.toBlocking(timeout: 2).first()
          guard let isFavorite = isFavoriteSubject else {
            fail("It should emit a View State")
            return
          }
          let expected = true
          
          expect(isFavorite).toEventually(equal(expected))
        }
      }
      
      context("When Account Use Case State Retrieves isFavorite State") {
        it("Should ViewModel isFavorite contains False") {
          // given
          fetchTVShowDetailsUseCaseMock.result = self.detailResult
          fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: false, isWatchList: true)
          
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
          let isFavoriteSubject = try? viewModel.isFavorite.toBlocking(timeout: 2).first()
          guard let isFavorite = isFavoriteSubject else {
            fail("It should emit a View State")
            return
          }
          let expected = false
          
          expect(isFavorite).toEventually(equal(expected))
        }
      }
      
      context("When Account Use Case State Retrieves isWatchList State") {
        it("Should ViewModel isWatchList contains True") {
          // given
          let isInitialWatchList = true
          
          fetchTVShowDetailsUseCaseMock.result = self.detailResult
          fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: true, isWatchList: isInitialWatchList)
          
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
          let isWatchListSubject = try? viewModel.isWatchList.toBlocking(timeout: 2).first()
          guard let isWatchListObserver = isWatchListSubject else {
            fail("It should emit a View State")
            return
          }
          
          expect(isWatchListObserver).toEventually(equal(isInitialWatchList))
        }
      }
      
      context("When Account Use Case State Retrieves isWatchList State") {
        it("Should ViewModel isWatchList contains False") {
          // given
          let isInitialWatchList = false
          
          fetchTVShowDetailsUseCaseMock.result = self.detailResult
          fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: true, isWatchList: isInitialWatchList)
          
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
          let isWatchListSubject = try? viewModel.isWatchList.toBlocking(timeout: 2).first()
          guard let isWatchListObserver = isWatchListSubject else {
            fail("It should emit a View State")
            return
          }
          
          expect(isWatchListObserver).toEventually(equal(isInitialWatchList))
        }
      }
    }
  }
}
