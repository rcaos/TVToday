//
//  ResultsSearchViewTests.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import FBSnapshotTestCase
import RxSwift

@testable import SearchShows
@testable import Shared
@testable import Persistence

class ResultsSearchViewTests: FBSnapshotTestCase {
  
  private var rootWindow: UIWindow!
  
  override func setUp() {
    super.setUp()
    //self.recordMode = true
    
    rootWindow = UIWindow(frame: UIScreen.main.bounds)
    rootWindow.isHidden = false
  }
  
  func test_WhenViewInitial_thenShowInitialScreen() {
    // given
    let recent = ["Breaking Bad", "Rick and Morty", "Dark"]
    let dataSource = createSectionModel(recentSearchs: recent, resultShows: [])
    let viewModel = ResultsSearchViewModelMock(state: .initial, source: dataSource)
    
    let viewController = ResultsSearchViewController(viewModel: viewModel)
    rootWindow.rootViewController = viewController
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let viewModel = ResultsSearchViewModelMock(state: .loading)
    let viewController = ResultsSearchViewController(viewModel: viewModel)
    rootWindow.rootViewController = viewController
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewIsPopulated_thenShowPopulatedScreen() {
    // given
    let shows = [
      TVShow.stub(id: 1, name: "Show 1", voteAverage: 1.0, posterPath: nil),
      TVShow.stub(id: 2, name: "Show 2", voteAverage: 2.0, posterPath: nil),
      TVShow.stub(id: 3, name: "Show 3", voteAverage: 3.0, posterPath: nil)
    ]
    let dataSource = createSectionModel(recentSearchs: [], resultShows: shows)
    
    let viewModel = ResultsSearchViewModelMock(state: .populated, source: dataSource)
    
    let viewController = ResultsSearchViewController(viewModel: viewModel)
    rootWindow.rootViewController = viewController
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    // given
    let viewModel = ResultsSearchViewModelMock(state: .empty)
    let viewController = ResultsSearchViewController(viewModel: viewModel)
    rootWindow.rootViewController = viewController
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewDidError_thenShowErrorScreen() {
    // given
    let viewModel = ResultsSearchViewModelMock(state: .error("Error to Fetch Shows"))
    let viewController = ResultsSearchViewController(viewModel: viewModel)
    rootWindow.rootViewController = viewController
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  // MARK: - Map Results
  
  fileprivate func createSectionModel(recentSearchs: [String], resultShows: [TVShow]) -> [ResultSearchSectionModel] {
    var dataSource: [ResultSearchSectionModel] = []
    
    let recentSearchsItem = recentSearchs.map { ResultSearchSectionItem.recentSearchs(items: $0) }
    
    let resultsShowsItem = resultShows
      .map { TVShowCellViewModel(show: $0) }
      .map { ResultSearchSectionItem.results(items: $0) }
    
    if !recentSearchsItem.isEmpty {
      dataSource.append(.recentSearchs(items: recentSearchsItem))
    }
    
    if !resultsShowsItem.isEmpty {
      dataSource.append(.results(items: resultsShowsItem))
    }
    
    return dataSource
  }
}

final class ResultsSearchViewModelMock: ResultsSearchViewModelProtocol {
  func recentSearchIsPicked(query: String) { }
  
  func showIsPicked(idShow: Int) { }
  
  func searchShows(with query: String) { }
  
  func resetSearch() { }
  
  var viewState: Observable<ResultViewState>
  
  var dataSource: Observable<[ResultSearchSectionModel]>
  
  weak var delegate: ResultsSearchViewModelDelegate?
  
  func getViewState() -> ResultViewState {
    return state
  }
  
  private let state: ResultViewState
  
  init(state: ResultViewState, source: [ResultSearchSectionModel] = []) {
    self.state = state
    viewState = Observable.just(state)
    
    dataSource = Observable.just(source)
  }
}
