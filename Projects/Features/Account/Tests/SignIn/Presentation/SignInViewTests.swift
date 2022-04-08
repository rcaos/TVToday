//
//  SignInViewTests.swift
//  AccountTests
//
//  Created by Jeans Ruiz on 20/12/21.
//

import XCTest
import SnapshotTesting
@testable import Account

class SignInViewTests: XCTestCase {

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsInitial_thenShowInitialScreen() {
    // given
    let signInViewModel = SignInViewModelMock(state: .initial)

    // when
    let viewController = SignInViewController(viewModel: signInViewModel)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))

    // when
    let lightViewController = SignInViewController(viewModel: signInViewModel)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let signInViewModel = SignInViewModelMock(state: .loading)

    // when
    let viewController = SignInViewController(viewModel: signInViewModel)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))

    // when
    let lightViewController = SignInViewController(viewModel: signInViewModel)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let signInViewModel = SignInViewModelMock(state: .error)
    let viewController = SignInViewController(viewModel: signInViewModel)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))

    // when
    let lightViewController = SignInViewController(viewModel: signInViewModel)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }
}
