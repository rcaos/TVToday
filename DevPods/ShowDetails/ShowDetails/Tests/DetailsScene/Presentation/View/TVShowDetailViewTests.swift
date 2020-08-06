//
//  TVShowDetailViewTests.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/30/20.
//

import FBSnapshotTestCase
import RxSwift
import RxCocoa

@testable import ShowDetails
@testable import Shared

class TVShowDetailViewTests: FBSnapshotTestCase {
  
  override func setUp() {
    super.setUp()
    //self.recordMode = true
  }
  
  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let initialState = TVShowDetailViewModelMock(state: .loading)
    let viewController = TVShowDetailViewController.create(with: initialState)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    // given
    let initialState = TVShowDetailViewModelMock(state: .populated( TVShowDetailInfo.stub() ))
    let viewController = TVShowDetailViewController.create(with: initialState)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let initialState = TVShowDetailViewModelMock(state: .error("Error to Fetch Details"))
    let viewController = TVShowDetailViewController.create(with: initialState)
    
    FBSnapshotVerifyView(viewController.view)
  }
}
