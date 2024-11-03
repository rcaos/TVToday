//
//  Created by Jeans Ruiz on 20/12/21.
//

@testable import AccountFeature
import ConcurrencyExtras
import Shared
import SnapshotTesting
import UI
import XCTest

class AccountViewTests: XCTestCase {

  private let factory = AccountViewControllerFactoryMock()

  override class func setUp() {
    Strings.currentLocale = Locale(identifier: Language.en.rawValue)
  }

  override func invokeTest() {
    withMainSerialExecutor {
      super.invokeTest()
    }
  }

  override func setUp() {
    super.setUp()
    isRecording = false
//    defaultScheduler = .immediate
  }

  func test_WhenViewIsLogin_thenShowLoginScreen() async {
    // given
    let accountViewModel = AccountViewModelMock(state: .login)

    // when
    let viewController = await AccountViewController(viewModel: accountViewModel, viewControllersFactory: factory)
    configureWith(viewController, style: .dark)
    await Task.yield()

    // then
    assertSnapshot(of: viewController, as: Snapshotting.image(on: .iPhoneSe, precision: 0.98))

    // when
    let lightViewController = await AccountViewController(viewModel: accountViewModel, viewControllersFactory: factory)
    configureWith(lightViewController, style: .light)
    await Task.yield()

    // then
    assertSnapshot(of: lightViewController, as: Snapshotting.image(on: .iPhoneSe, precision: 0.98))
  }

  func test_WhenViewIsLogged_thenShowProfileScreen() async {
    // given
    let accountViewModel = AccountViewModelMock(state: .profile(account: Account.stub()))

    // when
    let viewController = await AccountViewController(viewModel: accountViewModel, viewControllersFactory: factory)
    configureWith(viewController, style: .dark)
    await Task.yield()

    // then
    assertSnapshot(of: viewController, as: Snapshotting.image(on: .iPhoneSe, precision: 0.98))

    // when
    let lightViewController = await AccountViewController(viewModel: accountViewModel, viewControllersFactory: factory)
    configureWith(lightViewController, style: .light)
    await Task.yield()

    // then
    assertSnapshot(of: lightViewController, as: Snapshotting.image(on: .iPhoneSe, precision: 0.98))
  }
}
