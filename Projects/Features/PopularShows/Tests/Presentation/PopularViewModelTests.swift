//
//  PopularViewModelTests.swift
//  PopularShows-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

import Quick
import Nimble
import RxSwift
import RxBlocking

@testable import PopularShows
@testable import Shared

class PopularViewModelTests: QuickSpec {
  
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
  
  override func spec() {
    describe("PopularsViewModel") {
      var fetchUseCaseMock: FetchShowsUseCaseMock!
      beforeEach {
        fetchUseCaseMock = FetchShowsUseCaseMock()
      }
      
      context("When waiting for response of Fetch Use Case") {
        it("Should ViewModel contanins Loading State") {
          // given
          // not response yet
          
          let viewModel: PopularViewModelProtocol = PopularViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)
          
          // when
          viewModel.viewDidLoad()
          
          // when
          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected = SimpleViewState<TVShowCellViewModel>.loading
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
      
      context("When Fetch Use Case Retrieve First page") {
        it("Should ViewModel contains only First page") {
          // given
          fetchUseCaseMock.result = self.firstPage
          let firstPageCells = self.firstPage.results!.map { TVShowCellViewModel(show: $0) }
          
          let viewModel: PopularViewModelProtocol = PopularViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)
          
          // when
          viewModel.viewDidLoad()
          
          // then
          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected = SimpleViewState<TVShowCellViewModel>.paging(firstPageCells, next: 2)
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
      
      context("When Fetch Use Case Retrieve First and Second Page") {
        it("Should ViewModel contains First and Second page") {
          
          let totalCells = (self.firstPage.results + self.secondPage.results)
            .map { TVShowCellViewModel(show: $0) }
          
          // given
          fetchUseCaseMock.result = self.firstPage
          
          let viewModel: PopularViewModelProtocol = PopularViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)
          
          // when
          viewModel.viewDidLoad()
          fetchUseCaseMock.result = self.secondPage
          viewModel.didLoadNextPage()
          
          //then
          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected = SimpleViewState<TVShowCellViewModel>.populated(totalCells)
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
      
      context("When Fetch Use Case Returns Error") {
        it("Should ViewModel contanins Error") {
          // given
          fetchUseCaseMock.error = CustomError.genericError
          
          let viewModel: PopularViewModelProtocol = PopularViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)
          
          // when
          viewModel.viewDidLoad()
          
          // when
          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected = SimpleViewState<TVShowCellViewModel>.error("")
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
      
      context("When Fetch Use Case Returns Zero Shows") {
        it("Should ViewModel contanins Empty State") {
          // given
          fetchUseCaseMock.result = self.emptyPage
          
          let viewModel: PopularViewModelProtocol = PopularViewModel(fetchTVShowsUseCase: fetchUseCaseMock, coordinator: nil)
          
          // when
          viewModel.viewDidLoad()
          
          // when
          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected = SimpleViewState<TVShowCellViewModel>.empty
          
          expect(currentViewState).toEventually(equal(expected))
        }
      }
    }
  }
}
