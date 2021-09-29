//
//  TVShowDetailViewModelTapsTests.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/5/20.
//

import Quick
import Nimble
import RxSwift
import RxBlocking
import RxTest

@testable import ShowDetails
@testable import Shared

class TVShowDetailViewModelTapsTests: QuickSpec {
  
  let detailResult = TVShowDetailResult.stub()
  
  override func spec() {
    describe("TVShowDetailViewModel Taps for Logged Users") {
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
      
      context("When ViewModel receive isFavorite tap") {
        it("Should ViewModel isFavorite Observable change") {
          // given
          let initialFavoriteState = true
          
          fetchTVShowDetailsUseCaseMock.result = self.detailResult
          fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: initialFavoriteState, isWatchList: false)
          
          let scheduler = TestScheduler(initialClock: 0)
          let disposeBag = DisposeBag()
          let favoriteObserver = scheduler.createObserver(Bool.self)
          
          markAsFavoriteUseCaseMock.result = !initialFavoriteState
          
          let viewModel: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
            1,
            fetchLoggedUser: fetchLoggedUserMock,
            fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
            fetchTvShowState: fetchTVAccountStateMock,
            markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
            saveToWatchListUseCase: saveToWatchListUseCaseMock,
            coordinator: nil
          )
          
          viewModel.isFavorite
            .bind(to: favoriteObserver)
            .disposed(by: disposeBag)
          
          // when
          viewModel.viewDidLoad()
          
          // Emit taps from View
          scheduler.createColdObservable([.next(10, ())])
            .bind(to: viewModel.tapFavoriteButton)
            .disposed(by: disposeBag)
          scheduler.start()
          
          // then
          let expected: [Recorded<Event<Bool>>] =
            [.next(0, false),
             .next(0, initialFavoriteState),
             .next(10, !initialFavoriteState)]

          expect(favoriteObserver.events)
            .toEventually(equal(expected), timeout: .milliseconds(500))
        }
      }
      
      context("When ViewModel receive isWatched tap") {
        it("Should ViewModel isWatched Observable change") {
          // given
          let initialStateWatched = false
          
          fetchTVShowDetailsUseCaseMock.result = self.detailResult
          fetchTVAccountStateMock.result = TVShowAccountStateResult.stub(id: 1, isFavorite: true, isWatchList: initialStateWatched)
          
          let scheduler = TestScheduler(initialClock: 0)
          let disposeBag = DisposeBag()
          let watchedObserver = scheduler.createObserver(Bool.self)
          
          saveToWatchListUseCaseMock.result = !initialStateWatched
          
          let viewModel: TVShowDetailViewModelProtocol = TVShowDetailViewModel(
            1,
            fetchLoggedUser: fetchLoggedUserMock,
            fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
            fetchTvShowState: fetchTVAccountStateMock,
            markAsFavoriteUseCase: markAsFavoriteUseCaseMock,
            saveToWatchListUseCase: saveToWatchListUseCaseMock,
            coordinator: nil
          )
          
          viewModel.isWatchList
            .bind(to: watchedObserver)
            .disposed(by: disposeBag)
          
          // when
          viewModel.viewDidLoad()
          
          // Emit taps from View
          scheduler.createColdObservable([.next(10, ())])
            .bind(to: viewModel.tapWatchedButton)
            .disposed(by: disposeBag)
          scheduler.start()
          
          // then
          let expected: [Recorded<Event<Bool>>] =
            [.next(0, false),
             .next(0, initialStateWatched),
             .next(10, !initialStateWatched)]
          
          expect(watchedObserver.events)
            .toEventually(equal(expected), timeout: .milliseconds(500))
        }
      }
    }
  }
}
