//
//  ResultsSearchViewModelTests.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import Quick
import Nimble
import RxSwift
import RxBlocking

@testable import SearchShows
@testable import Persistence
@testable import Shared

class ResultsSearchViewModelTests: QuickSpec {
  
  let showsVisited: [ShowVisited] = [
    ShowVisited.stub(id: 1, pathImage: ""),
    ShowVisited.stub(id: 2, pathImage: ""),
    ShowVisited.stub(id: 3, pathImage: "")
  ]
  
  let genres: [Genre] = [
    Genre.stub(id: 1, name: "Genre 1"),
    Genre.stub(id: 2, name: "Genre 2")
  ]
  
  override func spec() {
    describe("ResultsSearchViewModel") {
      var searchTVShowsUseCaseMock: SearchTVShowsUseCaseMock!
      var fetchSearchsUseCaseMock: FetchSearchsUseCaseMock!
      
      beforeEach {
        searchTVShowsUseCaseMock = SearchTVShowsUseCaseMock()
        fetchSearchsUseCaseMock = FetchSearchsUseCaseMock()
      }
      
      context("When waiting for response of Fetch Use Case") {
        it("Should ViewModel contanins Loading State") {
          // given
          // not response yet
          
          let viewModel: ResultsSearchViewModelProtocol = ResultsSearchViewModel(
            searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)
          
          // when
          
          // then
          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected = ResultViewState.initial
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
      
      context("When Fetch Use Case Retrieve Recent Searchs") {
        it("Should ViewModel contains Recent Searchs Data") {
          
          // given
          let recent = ["Breaking Bad", "Rick and Morty", "Dark"]
          let expectedData = self.createSectionModel(recentSearchs: recent, resultShows: [])
          
          fetchSearchsUseCaseMock.result = recent.map { Search(query: $0) }
          
          let viewModel: ResultsSearchViewModelProtocol = ResultsSearchViewModel(
            searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)
          
          // when
          
          // then
          let dataSource = try? viewModel.dataSource.toBlocking(timeout: 2).first()
          guard let data = dataSource else {
            fail("It should emit a View State")
            return
          }
          
          expect(data).toEventually(equal(expectedData))
        }
      }
      
      context("When Search Use Case dont response yet") {
        it("Should ViewModel contains Loading state") {
          
          // given
          let viewModel: ResultsSearchViewModelProtocol = ResultsSearchViewModel(
            searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)
          
          // when
          viewModel.searchShows(with: "something")
          
          // then
          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          
          let expected = ResultViewState.loading
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
      
      context("When Search Use Case response with no results") {
        it("Should ViewModel contains Empty State") {
          
          // given
          searchTVShowsUseCaseMock.result = TVShowResult(page: 1, results: [], totalResults: 0, totalPages: 0)
          
          let viewModel: ResultsSearchViewModelProtocol = ResultsSearchViewModel(
            searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)
          
          // when
          viewModel.searchShows(with: "something")
          
          // then
          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          
          let expected = ResultViewState.empty
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
      
      context("When Search Use Case response With Shows") {
        it("Should ViewModel contains Populated State") {
          
          // given
          let shows: [TVShow] = [
            TVShow.stub(id: 1, name: "Show 1"),
            TVShow.stub(id: 2, name: "Show 2")
          ]
          searchTVShowsUseCaseMock.result = TVShowResult(page: 1, results: shows, totalResults: 1, totalPages: 1)
          
          let viewModel: ResultsSearchViewModelProtocol = ResultsSearchViewModel(
            searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)
          
          // when
          viewModel.searchShows(with: "something")
          
          // then
          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          
          let expected = ResultViewState.populated
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
      
      context("When Search Use Case response With Shows") {
        it("Should ViewModel contains Shows") {
          
          // given
          let shows: [TVShow] = [
            TVShow.stub(id: 1, name: "something Show 1"),
            TVShow.stub(id: 2, name: "something Show 2")
          ]
          let expectedData = self.createSectionModel(recentSearchs: [], resultShows: shows)
          
          searchTVShowsUseCaseMock.result = TVShowResult(page: 1, results: shows, totalResults: 1, totalPages: 1)
          
          let viewModel: ResultsSearchViewModelProtocol = ResultsSearchViewModel(
            searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)
          
          // when
          viewModel.searchShows(with: "something")
          
          // then
          let data = try? viewModel.dataSource.toBlocking(timeout: 2).first()
          guard let dataSource = data else {
            fail("It should emit a View State")
            return
          }
          
          expect(dataSource).toEventually(equal(expectedData))
        }
      }
      
      context("When Search Use Case response With Error") {
        it("Should ViewModel contains Error State") {
          
          // given
          searchTVShowsUseCaseMock.error = CustomError.genericError
          
          let viewModel: ResultsSearchViewModelProtocol = ResultsSearchViewModel(
            searchTVShowsUseCase: searchTVShowsUseCaseMock, fetchRecentSearchsUseCase: fetchSearchsUseCaseMock)
          
          // when
          viewModel.searchShows(with: "something")
          
          // then
          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          
          let expected = ResultViewState.error(CustomError.genericError.localizedDescription)
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
    }
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
