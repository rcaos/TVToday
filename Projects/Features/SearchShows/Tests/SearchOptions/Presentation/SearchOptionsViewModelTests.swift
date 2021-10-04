//
//  PopularViewModelTests.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

// swiftlint:disable all

import Quick
import Nimble
import RxSwift
import RxBlocking

@testable import SearchShows
@testable import Persistence
@testable import Shared

class SearchOptionsViewModelTest: QuickSpec {

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
    describe("SearchOptionsViewModel") {
      var fetchGenresUseCaseMock: FetchGenresUseCaseMock!
      var fetchVisitedShowsUseCaseMock: FetchVisitedShowsUseCaseMock!
      var recentsDidChangeUseCaseMock: RecentVisitedShowDidChangeUseCaseMock!

      beforeEach {
        fetchVisitedShowsUseCaseMock = FetchVisitedShowsUseCaseMock()
        fetchGenresUseCaseMock = FetchGenresUseCaseMock()
        recentsDidChangeUseCaseMock = RecentVisitedShowDidChangeUseCaseMock()
      }

      context("When waiting for response of Fetch Use Case") {
        it("Should ViewModel contanins Loading State") {
          // given
          // not response yet

          let viewModel: SearchOptionsViewModelProtocol = SearchOptionsViewModel(
            fetchGenresUseCase: fetchGenresUseCaseMock,
            fetchVisitedShowsUseCase: fetchVisitedShowsUseCaseMock,
            recentVisitedShowsDidChange: recentsDidChangeUseCaseMock)

          // when
          viewModel.viewDidLoad()

          // when
          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected = SearchViewState.loading

          expect(currentViewState).toEventually(equal(expected))
        }
      }

      context("When Fetch Use Case Retrieve Data") {
        it("Should ViewModel contains Populated State") {

          // given
          fetchGenresUseCaseMock.result = GenreListResult(genres: self.genres )
          recentsDidChangeUseCaseMock.result = true
          fetchVisitedShowsUseCaseMock.result = self.showsVisited

          let viewModel: SearchOptionsViewModelProtocol =  SearchOptionsViewModel(
            fetchGenresUseCase: fetchGenresUseCaseMock,
            fetchVisitedShowsUseCase: fetchVisitedShowsUseCaseMock,
            recentVisitedShowsDidChange: recentsDidChangeUseCaseMock)

          // when
          viewModel.viewDidLoad()

          // then
          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected =  SearchViewState.populated

          expect(currentViewState).toEventually(equal(expected))
        }
      }

      context("When Fetch Use Case Returns Zero elements") {
        it("Should ViewModel contanins Empty State") {
          // given
          fetchGenresUseCaseMock.result = GenreListResult(genres: [] )
          recentsDidChangeUseCaseMock.result = true
          fetchVisitedShowsUseCaseMock.result = self.showsVisited

          let viewModel: SearchOptionsViewModelProtocol =  SearchOptionsViewModel(
            fetchGenresUseCase: fetchGenresUseCaseMock,
            fetchVisitedShowsUseCase: fetchVisitedShowsUseCaseMock,
            recentVisitedShowsDidChange: recentsDidChangeUseCaseMock)

          // when
          viewModel.viewDidLoad()

          // then
          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected =  SearchViewState.empty

          expect(currentViewState).toEventually(equal(expected))
        }
      }

      context("When Fetch Use Case Returns Zero Shows") {
        it("Should ViewModel contanins Empty State") {
          // given
          fetchGenresUseCaseMock.error = CustomError.genericError
          recentsDidChangeUseCaseMock.result = true
          fetchVisitedShowsUseCaseMock.result = self.showsVisited

          let viewModel: SearchOptionsViewModelProtocol =  SearchOptionsViewModel(
            fetchGenresUseCase: fetchGenresUseCaseMock,
            fetchVisitedShowsUseCase: fetchVisitedShowsUseCaseMock,
            recentVisitedShowsDidChange: recentsDidChangeUseCaseMock)

          // when
          viewModel.viewDidLoad()

          // when
          let viewState = try? viewModel.viewState.toBlocking(timeout: 2).first()
          guard let currentViewState = viewState else {
            fail("It should emit a View State")
            return
          }
          let expected = SearchViewState.error(CustomError.genericError.localizedDescription)

          expect(currentViewState).toEventually(equal(expected))
        }
      }
    }
  }
}
