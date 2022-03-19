//
//  AccountViewDarkTests.swift
//  AccountTests
//
//  Created by Jeans Ruiz on 20/12/21.
//

import XCTest
import SnapshotTesting
import RxSwift

@testable import Account

class AccountViewDarkTests: XCTestCase {

  private let factory = AccountViewControllerFactoryMock()

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsLogin_thenShowLoginScreen() {
    // given
    let accountViewModel = AccountViewModelMock(state: .login)

    let viewController = AccountViewController(viewModel: accountViewModel, viewControllersFactory: factory)
    viewController.overrideUserInterfaceStyle = .dark

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsLogged_thenShowProfileScreen() {
    // given
    let accountViewModel = AccountViewModelMock(state: .profile(account: AccountResult.stub()))

    let viewController = AccountViewController(viewModel: accountViewModel, viewControllersFactory: factory)
    viewController.overrideUserInterfaceStyle = .dark

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }
}
