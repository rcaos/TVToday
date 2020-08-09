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
    
    let signInViewModel = SignInViewModelMock(state: .initial)
    
    let profileViewModel = ProfileViewModelMock(account: AccountResult.stub())
    
    let signInVC = SignInViewController.create(with: signInViewModel)
    
    let profileVC = ProfileViewController.create(with: profileViewModel)
    
    let viewController = AccountViewController.create(with: accountViewModel,
                                                      signInViewController: signInVC,
                                                      profileViewController: profileVC)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewIsLogged_thenShowProfileScreen() {
    // given
    let accountViewModel = AccountViewModelMock(state: .profile)
    
    let signInViewModel = SignInViewModelMock(state: .initial)
    
    let profileViewModel = ProfileViewModelMock(account: AccountResult.stub())
    
    let signInVC = SignInViewController.create(with: signInViewModel)
    
    let profileVC = ProfileViewController.create(with: profileViewModel)
    
    let viewController = AccountViewController.create(with: accountViewModel,
                                                      signInViewController: signInVC,
                                                      profileViewController: profileVC)
    
    FBSnapshotVerifyView(viewController.view)
  }
}
