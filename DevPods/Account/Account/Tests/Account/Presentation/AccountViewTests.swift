//
//  AccountViewTests.swift
//  AccountTV
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import FBSnapshotTestCase
import RxSwift

@testable import AccountTV

class AccountViewTests: FBSnapshotTestCase {
  
  private var rootWindow: UIWindow!
  
  override func setUp() {
    super.setUp()
    //self.recordMode = true
    rootWindow = UIWindow(frame: UIScreen.main.bounds)
    rootWindow.isHidden = false
  }
  
  func test_WhenViewIsLogin_thenShowLoginScreen() {
    // given
    let accountViewModel = AccountViewModelMock(state: .login)
    
    let factory = AccountViewControllerFactoryMock()
    
    let viewController = AccountViewController(viewModel: accountViewModel, viewControllersFactory: factory)
    rootWindow.rootViewController = viewController
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewIsLogged_thenShowProfileScreen() {
    // given
    let accountViewModel = AccountViewModelMock(state: .profile(account: AccountResult.stub()))
    
    let factory = AccountViewControllerFactoryMock()
    
    let viewController = AccountViewController(viewModel: accountViewModel, viewControllersFactory: factory)
    rootWindow.rootViewController = viewController
    
    FBSnapshotVerifyView(viewController.view)
  }
}

// MARK: - AccountViewControllerFactory

class AccountViewControllerFactoryMock: AccountViewControllerFactory {
  func makeSignInViewController() -> UIViewController {
    let viewModel = SignInViewModelMock(state: .initial)
    return SignInViewController(viewModel: viewModel)
  }
  
  func makeProfileViewController(with account: AccountResult) -> UIViewController {
    let viewModel =  ProfileViewModelMock(account: account)
    return ProfileViewController(viewModel: viewModel)
  }
}
