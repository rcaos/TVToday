//
//  SignInViewModelTests.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import Combine
@testable import Account
@testable import Shared
import XCTest

class SignInViewModelTests: XCTestCase {

  var createTokenUseCase: CreateTokenUseCaseMock!
  private var disposeBag: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    createTokenUseCase = CreateTokenUseCaseMock()
    disposeBag = []
  }

  func test_UseCase_Doesnot_Called_ViewModel_Should_Contains_Initial_State() {
    // given
    let sut: SignInViewModelProtocol = SignInViewModel(createTokenUseCase: createTokenUseCase)

    // when
    let expected = [SignInViewState.initial]
    var received = [SignInViewState]()

    sut.viewState
      .removeDuplicates()
      .sink(receiveValue: { value in
        received.append(value)
      })
      .store(in: &disposeBag)

    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.01)

    // then
    XCTAssertEqual(expected, received, "Should only receives two Value")
  }
}

//      context("When UseCase RequestToken dont Respond yet") {
//        it("Should ViewModel contanins Loading State") {
//          // given
//          let viewStateObserver = scheduler.createObserver(SignInViewState.self)
//
//          let viewModel: SignInViewModelProtocol = SignInViewModel(createTokenUseCase: createTokenUseCase)
//
//          viewModel.viewState
//            .subscribe { event in
//              viewStateObserver.on(event)
//            }
//            .disposed(by: disposeBag)
//
//          // when
//          // Tap Button
//          scheduler.createColdObservable([.next(10, ())])
//            .subscribe { event in
//              viewModel.tapButton.on(event)
//            }
//            .disposed(by: disposeBag)
//          scheduler.start()
//
//          // then
//          let expected: [Recorded<Event<SignInViewState>>] = [
//            .next(0, .initial),
//            .next(10, .loading)
//          ]
//          expect(viewStateObserver.events).toEventually(equal(expected))
//        }
//      }
//
//      context("When UseCase RequestToken Repond with URL") {
//        it("Should ViewModel send URL to Delegate") {
//          // given
//          let expectedURL = URL(string: "someURL")
//          createTokenUseCase.result = expectedURL
//
//          let delegate = SignInViewModelDelegateMock()
//
//          var viewModel: SignInViewModelProtocol = SignInViewModel(createTokenUseCase: createTokenUseCase)
//          viewModel.delegate = delegate
//
//          // when
//          // Tap Button
//          scheduler.createColdObservable([.next(10, ())])
//            .subscribe { event in
//              viewModel.tapButton.on(event)
//            }
//            .disposed(by: disposeBag)
//          scheduler.start()
//
//          // then
//          expect(delegate.url).toEventually(equal(expectedURL))
//        }
//      }
