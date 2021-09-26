//
//  TVShowDetailViewTests.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/30/20.
//

//import FBSnapshotTestCase
//import RxSwift
//
//@testable import ShowDetails
//@testable import Shared
//
//class TVShowDetailViewTests: FBSnapshotTestCase {
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
//  func test_WhenViewIsLoading_thenShowLoadingScreen() {
//    // given
//    let initialState = TVShowDetailViewModelMock(state: .loading)
//    let viewController = TVShowDetailViewController(viewModel: initialState)
//    rootWindow.rootViewController = viewController
//    
//    FBSnapshotVerifyView(viewController.view)
//  }
//  
//  func test_WhenViewPopulated_thenShowPopulatedScreen() {
//    // given
//    let initialState = TVShowDetailViewModelMock(state: .populated( TVShowDetailInfo.stub() ))
//    let viewController = TVShowDetailViewController(viewModel: initialState)
//    rootWindow.rootViewController = viewController
//    
//    FBSnapshotVerifyView(viewController.view)
//  }
//  
//  func test_WhenViewIsError_thenShowErrorScreen() {
//    // given
//    let initialState = TVShowDetailViewModelMock(state: .error("Error to Fetch Details"))
//    let viewController = TVShowDetailViewController(viewModel: initialState)
//    rootWindow.rootViewController = viewController
//    
//    FBSnapshotVerifyView(viewController.view)
//  }
//}
