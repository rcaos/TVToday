//
//  AiringTodayViewTests.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/30/20.
//

import FBSnapshotTestCase
import RxSwift

@testable import PopularShows
@testable import Shared

class AiringTodayViewTests: FBSnapshotTestCase {
  
  let firstShow = TVShow.stub(id: 1, name: "title1 🐶", posterPath: "/1",
                              backDropPath: "/back1", overview: "overview")
  let secondShow = TVShow.stub(id: 2, name: "title2 🔫", posterPath: "/2",
                               backDropPath: "/back2", overview: "overview2")
  let thirdShow = TVShow.stub(id: 3, name: "title3 🚨", posterPath: "/3",
                              backDropPath: "/back3", overview: "overview3")
  
  lazy var firstPage = TVShowResult.stub(page: 1,
                                         results: [firstShow, secondShow],
                                         totalResults: 3,
                                         totalPages: 2)
  
  lazy var secondPage = TVShowResult.stub(page: 2,
                                          results: [thirdShow],
                                          totalResults: 3,
                                          totalPages: 2)
  
  let emptyPage = TVShowResult.stub(page: 1, results: [], totalResults: 0, totalPages: 1)
  
  override func setUp() {
    super.setUp()
    //self.recordMode = true
  }
  
  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let viewModel = PopularViewModelMock(state: .loading)
    let viewController = PopularsViewController.create(with: viewModel)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewPaging_thenShowPagingScreen() {
    
    let firsPageCells = firstPage.results!.map { TVShowCellViewModel(show: $0) }
    
    // given
    let viewModel = PopularViewModelMock(state: .paging(firsPageCells, next: 2) )
    let viewController = PopularsViewController.create(with: viewModel)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    
    let totalCells = (self.firstPage.results + self.secondPage.results)
      .map { TVShowCellViewModel(show: $0) }
    
    // given
    let viewModel = PopularViewModelMock(state: .populated(totalCells) )
    let viewController = PopularsViewController.create(with: viewModel)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    // given
    let viewModel = PopularViewModelMock(state: .empty)
    let viewController = PopularsViewController.create(with: viewModel)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let viewModel = PopularViewModelMock(state: .error("Error to Fetch Shows") )
    let viewController = PopularsViewController.create(with: viewModel)
    
    FBSnapshotVerifyView(viewController.view)
  }
}
