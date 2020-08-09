//
//  EpisodesListViewTests.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/6/20.
//

import FBSnapshotTestCase
import RxSwift

@testable import ShowDetails
@testable import Shared

class EpisodesListViewTests: FBSnapshotTestCase {
  
  var headerViewModel: SeasonHeaderViewModelMock!
  
  override func setUp() {
    super.setUp()
    //self.recordMode = true
    
    headerViewModel = SeasonHeaderViewModelMock(showName: "Dragon Ball Z (19987 - 1992)")
  }
  
  func test_WhenViewIsLoading_thenShow_LoadingScreen() {
    // given
    let initialState = EpisodesListViewModelMock(state: .loading)
    let viewController = EpisodesListViewController.create(with: initialState)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewModelDidPopulated_thenShow_PopulatedScreen() {
    // given
    let episodes = [
      Episode.stub(id: 1, episodeNumber: 1, name: "Chapter 1"),
      Episode.stub(id: 2, episodeNumber: 2, name: "Chapter 2"),
      Episode.stub(id: 3, episodeNumber: 3, name: "Chapter 3")
    ]
    let initialState = EpisodesListViewModelMock(state: .populated,
                                                 numberOfSeasons: 3,
                                                 seasonSelected: 1,
                                                 episodes: episodes,
                                                 headerViewModel: headerViewModel)
    let viewController = EpisodesListViewController.create(with: initialState)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewModelReturnsError_thenShow_ErrorScreen() {
    // given
    let initialState = EpisodesListViewModelMock(state: .error("Error to Fetch Show"))
    let viewController = EpisodesListViewController.create(with: initialState)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewModelLoadSeason_thenShow_LoadingSeasonScreen() {
    // given
    let initialState = EpisodesListViewModelMock(state: .loadingSeason,
                                                 headerViewModel: headerViewModel)
    let viewController = EpisodesListViewController.create(with: initialState)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewModelReturnsEmpty_thenShow_EmptyScreen() {
    // given
    let initialState = EpisodesListViewModelMock(state: .empty,
                                                 headerViewModel: headerViewModel)
    let viewController = EpisodesListViewController.create(with: initialState)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewModelReturnsErrorSeason_thenShow_ErrorSeasonScreen() {
    // given
    let initialState = EpisodesListViewModelMock(state: .errorSeason(""),
                                                 headerViewModel: headerViewModel)
    let viewController = EpisodesListViewController.create(with: initialState)
    
    FBSnapshotVerifyView(viewController.view)
  }
}
