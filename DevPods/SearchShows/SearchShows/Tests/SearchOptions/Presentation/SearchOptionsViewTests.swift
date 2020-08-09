//
//  SearchShows-Unit-Tests.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 7/30/20.
//

import FBSnapshotTestCase
import RxSwift

@testable import SearchShows
@testable import Shared
@testable import Persistence

class SearchOptionsViewTests: FBSnapshotTestCase {
  
  let showsVisited: [ShowVisited] = [
    ShowVisited.stub(id: 1, pathImage: ""),
    ShowVisited.stub(id: 2, pathImage: ""),
    ShowVisited.stub(id: 3, pathImage: "")
  ]
  
  let genres: [Genre] = [
    Genre.stub(id: 1, name: "Genre 1"),
    Genre.stub(id: 2, name: "Genre 2")
  ]
  
  override func setUp() {
    super.setUp()
    //self.recordMode = true
  }
  
  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let viewController = SearchOptionsViewController.create(with: SearchOptionsViewModelMock(state: .loading) )
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    // given
    let sections = createSectionModel(showsVisited: showsVisited, genres: genres)
    
    let viewModel = SearchOptionsViewModelMock(state: .populated, sections: sections)
    let viewController = SearchOptionsViewController.create(with: viewModel)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    // given
    let viewModel = SearchOptionsViewModelMock(state: .empty, sections: [])
    
    let viewController = SearchOptionsViewController.create(with: viewModel)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let viewModel = SearchOptionsViewModelMock(state: .error("Error to Fetch Genres"), sections: [])
    
    let viewController = SearchOptionsViewController.create(with: viewModel)
    
    FBSnapshotVerifyView(viewController.view)
  }
  
  // MARK: - Map data
  
  fileprivate func createSectionModel(showsVisited: [ShowVisited], genres: [Genre]) -> [SearchOptionsSectionModel] {
    
    var dataSource: [SearchOptionsSectionModel] = []
    
    let showsSectionItem = mapRecentShowsToSectionItem(recentsShows: showsVisited)
    
    if let recentShowsSection = showsSectionItem {
      dataSource.append(.showsVisited(items: [recentShowsSection]))
    }
    
    let genresSectionItem = mapGenreToSectionItem(genres: genres)
    
    if !genresSectionItem.isEmpty {
      dataSource.append(.genres(items: genresSectionItem))
    }
    
    return dataSource
  }
  
  fileprivate func mapRecentShowsToSectionItem(recentsShows: [ShowVisited]) -> SearchSectionItem? {
    
    let visitedModel = VisitedShowViewModelMock(showsMock: recentsShows)
    
    return recentsShows.isEmpty ? nil : .showsVisited(items: visitedModel)
  }
  
  fileprivate func mapGenreToSectionItem(genres: [Genre] ) -> [SearchSectionItem] {
    return genres
      .map { GenreViewModelMock(id: $0.id, name: $0.name) }
      .map { SearchSectionItem.genres(items: $0) }
  }
}
