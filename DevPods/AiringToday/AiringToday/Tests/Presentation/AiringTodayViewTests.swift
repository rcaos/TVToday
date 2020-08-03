//
//  AiringTodayViewTests.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/30/20.
//

import FBSnapshotTestCase
import RxSwift

@testable import AiringToday
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
    self.recordMode = true
  }
  
  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let viewController = AiringTodayViewController.create(with: AiringTodayViewModelMock(state: .loading) )
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewPaging_thenShowPagingScreen() {
    
    let firsPageCells = firstPage.results!.map { AiringTodayCollectionViewModel(show: $0) }
    
    // given
    let viewController = AiringTodayViewController.create(with: AiringTodayViewModelMock(state: .paging(firsPageCells, next: 2) ) )
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    
    let totalCells = (self.firstPage.results + self.secondPage.results)
               .map { AiringTodayCollectionViewModel(show: $0) }
    
    // given
    let viewController = AiringTodayViewController.create(with: AiringTodayViewModelMock(state: .populated(totalCells) ) )
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    // given
    let viewController = AiringTodayViewController.create(with: AiringTodayViewModelMock(state: .empty ) )
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let viewController = AiringTodayViewController.create(with: AiringTodayViewModelMock(state: .error("Error to Fetch Shows") ) )
    
    FBSnapshotVerifyView(viewController.view)
  }
  
}

// MARK: AiringTodayViewModelProtocol

class AiringTodayViewModelMock: AiringTodayViewModelProtocol {
  
  func viewDidLoad() { }
  
  func didLoadNextPage() { }
  
  func showIsPicked(with id: Int) { }
  
  func refreshView() { }
  
  func getCurrentViewState() -> SimpleViewState<AiringTodayCollectionViewModel> {
    if let currentViewState = try? viewStateObservableSubject.value() {
      return currentViewState
    }
    return .empty
  }
  
  var viewState: Observable<SimpleViewState<AiringTodayCollectionViewModel>>
  
  var viewStateObservableSubject: BehaviorSubject<SimpleViewState<AiringTodayCollectionViewModel>>
  
  init(state: SimpleViewState<AiringTodayCollectionViewModel>) {
    viewStateObservableSubject = BehaviorSubject(value: state)
    viewState = viewStateObservableSubject.asObservable()
  }
}
