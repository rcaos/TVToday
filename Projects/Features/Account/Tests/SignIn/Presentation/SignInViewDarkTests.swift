//
//  SignInViewDarkTests.swift
//  AccountTests
//
//  Created by Jeans Ruiz on 20/12/21.
//

import XCTest
import SnapshotTesting
@testable import Account

class SignInViewDarkTests: XCTestCase {

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsInitial_thenShowInitialScreen() {
    // given
    let signInViewModel = SignInViewModelMock(state: .initial)
    let viewController = SignInViewController(viewModel: signInViewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let signInViewModel = SignInViewModelMock(state: .loading)
    let viewController = SignInViewController(viewModel: signInViewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let signInViewModel = SignInViewModelMock(state: .error)
    let viewController = SignInViewController(viewModel: signInViewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }
}
