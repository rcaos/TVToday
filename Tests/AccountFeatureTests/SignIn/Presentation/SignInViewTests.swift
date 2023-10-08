//
//  SignInViewTests.swift
//  AccountTests
//
//  Created by Jeans Ruiz on 20/12/21.
//

import XCTest
import SnapshotTesting
import UI
@testable import AccountFeature

class SignInViewTests: XCTestCase {

  override func setUp() {
    super.setUp()
    defaultScheduler = .immediate
    isRecording = false
  }

  func test_WhenViewIsInitial_thenShowInitialScreen() {
    // given
    let signInViewModel = SignInViewModelMock(state: .initial)

    // when
    let viewController = SignInViewController(viewModel: signInViewModel)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.98))

    // when
    let lightViewController = SignInViewController(viewModel: signInViewModel)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.98))
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let signInViewModel = SignInViewModelMock(state: .loading)

    // when
    let viewController = SignInViewController(viewModel: signInViewModel)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.98))

    // when
    let lightViewController = SignInViewController(viewModel: signInViewModel)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.98))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let signInViewModel = SignInViewModelMock(state: .error)
    let viewController = SignInViewController(viewModel: signInViewModel)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.98))

    // when
    let lightViewController = SignInViewController(viewModel: signInViewModel)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.98))
  }
}
