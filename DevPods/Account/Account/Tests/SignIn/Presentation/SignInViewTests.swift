//
//  SignInViewTests.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import FBSnapshotTestCase
import RxSwift

@testable import AccountTV

class SignInViewTests: FBSnapshotTestCase {
  
  override func setUp() {
    super.setUp()
    //self.recordMode = true
  }
  
  func test_WhenViewIsInitial_thenShowInitialScreen() {
    // given
    let signInViewModel = SignInViewModelMock(state: .initial)
    
    let viewController = SignInViewController.create(with: signInViewModel)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let signInViewModel = SignInViewModelMock(state: .loading)
    
    let viewController = SignInViewController.create(with: signInViewModel)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let signInViewModel = SignInViewModelMock(state: .error)
    
    let viewController = SignInViewController.create(with: signInViewModel)
    
    FBSnapshotVerifyView(viewController.view)
  }
}
