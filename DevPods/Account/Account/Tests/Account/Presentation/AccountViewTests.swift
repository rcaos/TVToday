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
  
  override func setUp() {
    super.setUp()
    //self.recordMode = true
  }
  
  func test_WhenViewIsLogin_thenShowLoginScreen() {
    // given
    let accountViewModel = AccountViewModelMock(state: .login)
    
    let factory = AccountViewControllerFactoryMock()
    
    let viewController = AccountViewController.create(with: accountViewModel, viewControllersFactory: factory)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewIsLogged_thenShowProfileScreen() {
    // given
    
    let accountViewModel = AccountViewModelMock(state: .profile(account: AccountResult.stub()))
    
    let factory = AccountViewControllerFactoryMock()
    
    let viewController = AccountViewController.create(with: accountViewModel, viewControllersFactory: factory)
    
    FBSnapshotVerifyView(viewController.view)
  }
}

// MARK: - AccountViewControllerFactory

class AccountViewControllerFactoryMock: AccountViewControllerFactory {
  func makeSignInViewController() -> UIViewController {
    let viewModel = SignInViewModelMock(state: .initial)
    return SignInViewController.create(with: viewModel)
  }
  
  func makeProfileViewController(with account: AccountResult) -> UIViewController {
    let viewModel =  ProfileViewModelMock(account: account)
    return ProfileViewController.create(with: viewModel)
  }
}
