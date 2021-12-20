//
//  PopularViewTests.swift
//  PopularShows-Unit-Tests
//
//  Created by Jeans Ruiz on 7/30/20.
//

import XCTest
import SnapshotTesting

@testable import PopularShows
@testable import Shared

class PopularViewTestsLight: XCTestCase {

  let firstShow = TVShow.stub(id: 1, name: "Dark 🐶", voteAverage: 8.0)
  let secondShow = TVShow.stub(id: 2, name: "Dragon Ball Z 🔫", voteAverage: 9.0)
  let thirdShow = TVShow.stub(id: 3, name: "Esto es un TVShow con un título muy grande creado con fines de test 🚨", voteAverage: 10.0)

  lazy var firstPage = TVShowResult.stub(page: 1,
                                         results: [firstShow, secondShow],
                                         totalResults: 3,
                                         totalPages: 2)

  lazy var secondPage = TVShowResult.stub(page: 2,
                                          results: [thirdShow],
                                          totalResults: 3,
                                          totalPages: 2)

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let viewModel = PopularViewModelMock(state: .loading)

    // when
    let viewController = PopularsViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewPaging_thenShowPagingScreen() {
    // given
    let firsPageCells = firstPage.results!.map { TVShowCellViewModel(show: $0) }

    // when
    let viewModel = PopularViewModelMock(state: .paging(firsPageCells, next: 2) )
    let viewController = PopularsViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    // given
    let totalCells = (self.firstPage.results + self.secondPage.results)
      .map { TVShowCellViewModel(show: $0) }

    // when
    let viewModel = PopularViewModelMock(state: .populated(totalCells) )
    let viewController = PopularsViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    // given
    let viewModel = PopularViewModelMock(state: .empty)

    // when
    let viewController = PopularsViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let viewModel = PopularViewModelMock(state: .error("Error to Fetch Shows") )

    // when
    let viewController = PopularsViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneSe)))
  }
}
