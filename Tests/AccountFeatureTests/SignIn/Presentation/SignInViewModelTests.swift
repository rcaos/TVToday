//
//  SignInViewModelTests.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import Combine
@testable import AccountFeature
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
    let sut: SignInViewModelProtocol = SignInViewModel(createTokenUseCase: createTokenUseCase, scheduler: .immediate)

    // when
    let expected = [SignInViewState.initial]
    var received = [SignInViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // then
    XCTAssertEqual(expected, received, "Should only receives two Value")
  }

  func test_UseCase_Doesnot_Responds_Yet_ViewModel_Should_Contains_Loading_State() {
    // given
    let sut: SignInViewModelProtocol = SignInViewModel(createTokenUseCase: createTokenUseCase, scheduler: .immediate)

    // when
    let expected = [
      SignInViewState.initial,
      SignInViewState.loading
    ]
    var received = [SignInViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.signInDidTapped()

    // then
    XCTAssertEqual(expected, received, "Should only receives two Value")
  }

  func test_UseCase_Respond_Successfully_ViewModel_Should_Calls_To_Delegate() {
    // given
    let expectedURL = URL(string: "someURL")
    createTokenUseCase.result = expectedURL
    let delegate = SignInViewModelDelegateMock()

    var sut: SignInViewModelProtocol = SignInViewModel(createTokenUseCase: createTokenUseCase, scheduler: .immediate)
    sut.delegate = delegate

    // when
    sut.signInDidTapped()

    // then
    XCTAssertEqual(expectedURL, delegate.url, "SignInViewModel should calls to delegate")
  }
}
