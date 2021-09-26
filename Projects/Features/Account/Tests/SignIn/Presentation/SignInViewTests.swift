//
//  SignInViewTests.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

// MARK: - TODO, change FBSnapshotTestCase

//import FBSnapshotTestCase
//import RxSwift
//
//@testable import Account
//
//class SignInViewTests: FBSnapshotTestCase {
//
//  private var rootWindow: UIWindow!
//
//  override func setUp() {
//    super.setUp()
//    //self.recordMode = true
//    rootWindow = UIWindow(frame: UIScreen.main.bounds)
//    rootWindow.isHidden = false
//  }
//
//  func test_WhenViewIsInitial_thenShowInitialScreen() {
//    // given
//    let signInViewModel = SignInViewModelMock(state: .initial)
//    let viewController = SignInViewController(viewModel: signInViewModel)
//    rootWindow.rootViewController = viewController
//
//    FBSnapshotVerifyView(viewController.view)
//  }
//
//  func test_WhenViewIsLoading_thenShowLoadingScreen() {
//    // given
//    let signInViewModel = SignInViewModelMock(state: .loading)
//    let viewController = SignInViewController(viewModel: signInViewModel)
//    rootWindow.rootViewController = viewController
//
//    FBSnapshotVerifyView(viewController.view)
//  }
//
//  func test_WhenViewIsError_thenShowErrorScreen() {
//    // given
//    let signInViewModel = SignInViewModelMock(state: .error)
//    let viewController = SignInViewController(viewModel: signInViewModel)
//    rootWindow.rootViewController = viewController
//
//    FBSnapshotVerifyView(viewController.view)
//  }
//}
