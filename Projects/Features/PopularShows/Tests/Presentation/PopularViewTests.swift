//
//  PopularViewTests.swift
//  PopularShows-Unit-Tests
//
//  Created by Jeans Ruiz on 7/30/20.
//

// swiftlint:disable all

//import FBSnapshotTestCase
//
//@testable import PopularShows
//@testable import Shared
//
//class PopularViewTests: FBSnapshotTestCase {
//  
//  let firstShow = TVShow.stub(id: 1, name: "Dark 🐶", voteAverage: 8.0)
//  let secondShow = TVShow.stub(id: 2, name: "Dragon Ball Z 🔫", voteAverage: 9.0)
//  let thirdShow = TVShow.stub(id: 3, name: "Esto es un TVShow con un título muy grande creado con fines de test 🚨", voteAverage: 10.0)
//  
//  lazy var firstPage = TVShowResult.stub(page: 1,
//                                         results: [firstShow, secondShow],
//                                         totalResults: 3,
//                                         totalPages: 2)
//  
//  lazy var secondPage = TVShowResult.stub(page: 2,
//                                          results: [thirdShow],
//                                          totalResults: 3,
//                                          totalPages: 2)
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
//    let viewModel = PopularViewModelMock(state: .loading)
//    let viewController = PopularsViewController(viewModel: viewModel)
//    rootWindow.rootViewController = viewController
//    
//    FBSnapshotVerifyView(viewController.view)
//  }
//  
//  func test_WhenViewPaging_thenShowPagingScreen() {
//    
//    let firsPageCells = firstPage.results!.map { TVShowCellViewModel(show: $0) }
//    
//    // given
//    let viewModel = PopularViewModelMock(state: .paging(firsPageCells, next: 2) )
//    let viewController = PopularsViewController(viewModel: viewModel)
//    rootWindow.rootViewController = viewController
//    
//    FBSnapshotVerifyView(viewController.view)
//  }
//  
//  func test_WhenViewPopulated_thenShowPopulatedScreen() {
//    
//    let totalCells = (self.firstPage.results + self.secondPage.results)
//      .map { TVShowCellViewModel(show: $0) }
//    
//    // given
//    let viewModel = PopularViewModelMock(state: .populated(totalCells) )
//    let viewController = PopularsViewController(viewModel: viewModel)
//    rootWindow.rootViewController = viewController
//    
//    FBSnapshotVerifyView(viewController.view)
//  }
//  
//  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
//    // given
//    let viewModel = PopularViewModelMock(state: .empty)
//    let viewController = PopularsViewController(viewModel: viewModel)
//    rootWindow.rootViewController = viewController
//    
//    FBSnapshotVerifyView(viewController.view)
//  }
//  
//  func test_WhenViewIsError_thenShowErrorScreen() {
//    // given
//    let viewModel = PopularViewModelMock(state: .error("Error to Fetch Shows") )
//    let viewController = PopularsViewController(viewModel: viewModel)
//    rootWindow.rootViewController = viewController
//    
//    FBSnapshotVerifyView(viewController.view)
//  }
//}
