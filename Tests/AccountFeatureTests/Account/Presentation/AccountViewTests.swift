//
//  AccountViewTests.swift
//  AccountTests
//
//  Created by Jeans Ruiz on 20/12/21.
//

import XCTest
import SnapshotTesting
import Shared
import UI
@testable import AccountFeature

class AccountViewTests: XCTestCase {

  private let factory = AccountViewControllerFactoryMock()

  override class func setUp() {
    Strings.currentLocale = Locale(identifier: Language.en.rawValue)
  }

  override func setUp() {
    super.setUp()
    isRecording = false
    defaultScheduler = .immediate
  }

  func test_WhenViewIsLogin_thenShowLoginScreen() {
    // given
    let accountViewModel = AccountViewModelMock(state: .login)

    // when
    let viewController = AccountViewController(viewModel: accountViewModel, viewControllersFactory: factory)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(of: viewController, as: Snapshotting.image(on: .iPhoneSe, precision: 0.98))

    // when
    let lightViewController = AccountViewController(viewModel: accountViewModel, viewControllersFactory: factory)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(of: lightViewController, as: Snapshotting.image(on: .iPhoneSe, precision: 0.98))
  }

  func test_WhenViewIsLogged_thenShowProfileScreen() {
    // given
    let accountViewModel = AccountViewModelMock(state: .profile(account: Account.stub()))

    // when
    let viewController = AccountViewController(viewModel: accountViewModel, viewControllersFactory: factory)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(of: viewController, as: Snapshotting.image(on: .iPhoneSe, precision: 0.98))

    // when
    let lightViewController = AccountViewController(viewModel: accountViewModel, viewControllersFactory: factory)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(of: lightViewController, as: Snapshotting.image(on: .iPhoneSe, precision: 0.98))
  }
}
