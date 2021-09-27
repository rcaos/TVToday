//
//  SignInViewModelTests.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxBlocking
import RxTest

@testable import Account
@testable import Shared

class SignInViewModelTests: QuickSpec {
  
  override func spec() {
    describe("SignInViewModel") {
      
      var createTokenUseCase: CreateTokenUseCaseMock!
      
      var scheduler: TestScheduler!
      var disposeBag: DisposeBag!
      
      beforeEach {
        createTokenUseCase = CreateTokenUseCaseMock()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
      }
      
      context("When dont called to UseCase yet") {
        it("Should ViewModel contanins Initial State") {
          // given
          
          let viewModel: SignInViewModelProtocol = SignInViewModel(createTokenUseCase: createTokenUseCase)
          
          // then
          let viewState = try? viewModel.viewState.toBlocking(timeout: 1).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected = SignInViewState.initial
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
      
      context("When UseCase RequestToken dont Respond yet") {
        it("Should ViewModel contanins Loading State") {
          // given
          let viewStateObserver = scheduler.createObserver(SignInViewState.self)
          
          let viewModel: SignInViewModelProtocol = SignInViewModel(createTokenUseCase: createTokenUseCase)
          
          viewModel.viewState
            .bind(to: viewStateObserver)
            .disposed(by: disposeBag)
          
          // when
          // Tap Button
          scheduler.createColdObservable([.next(10, ())])
            .bind(to: viewModel.tapButton)
            .disposed(by: disposeBag)
          scheduler.start()
          
          //then
          let expected: [Recorded<Event<SignInViewState>>] = [
            .next(0, .initial),
            .next(10, .loading)
          ]
          expect(viewStateObserver.events).toEventually(equal(expected))
        }
      }
      
      context("When UseCase RequestToken Repond with URL") {
        it("Should ViewModel send URL to Delegate") {
          // given
          let expectedURL = URL(string: "someURL")
          createTokenUseCase.result = expectedURL
          
          let delegate = SignInViewModelDelegateMock()
          
          var viewModel: SignInViewModelProtocol = SignInViewModel(createTokenUseCase: createTokenUseCase)
          viewModel.delegate = delegate
          
          // when
          // Tap Button
          scheduler.createColdObservable([.next(10, ())])
            .bind(to: viewModel.tapButton)
            .disposed(by: disposeBag)
          scheduler.start()
          
          //then
          expect(delegate.url).toEventually(equal(expectedURL))
        }
      }
    }
  }
}
