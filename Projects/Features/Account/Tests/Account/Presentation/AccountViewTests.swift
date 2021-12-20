//
//  AccountViewLightTests.swift
//  AccountTV
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import XCTest
import SnapshotTesting
import RxSwift

@testable import Account

class AccountViewLightTests: XCTestCase {

  private let factory = AccountViewControllerFactoryMock()

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsLogin_thenShowLoginScreen() {
    // given
    let accountViewModel = AccountViewModelMock(state: .login)

    let viewController = AccountViewController(viewModel: accountViewModel, viewControllersFactory: factory)
    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsLogged_thenShowProfileScreen() {
    // given
    let accountViewModel = AccountViewModelMock(state: .profile(account: AccountResult.stub()))

    let viewController = AccountViewController(viewModel: accountViewModel, viewControllersFactory: factory)
    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneSe)))
  }
}
