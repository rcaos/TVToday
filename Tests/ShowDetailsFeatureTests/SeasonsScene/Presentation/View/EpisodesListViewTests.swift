//
//  EpisodesListViewTests.swift
//  ShowDetailsTests
//
//  Created by Jeans Ruiz on 19/12/21.
//

import SnapshotTesting
import XCTest
import CombineSchedulers

@testable import ShowDetailsFeature
@testable import Shared
import UI

func configureWith(_ viewController: UIViewController, style: UIUserInterfaceStyle) {
  viewController.overrideUserInterfaceStyle = style
  _ = viewController.view
}

class EpisodesListViewTests: XCTestCase {

  private var headerViewModel: SeasonHeaderViewModel!

  override class func setUp() {
    Strings.currentLocale = Locale(identifier: Language.en.rawValue)
  }

  override func setUp() {
    super.setUp()
    defaultScheduler = .immediate
    isRecording = false
    headerViewModel = .mock("Dragon Ball Z", "1987-01-01", "1992-01-01")
  }

  func test_WhenViewIsLoading_thenShow_LoadingScreen() {
    // given
    let initialState = EpisodesListViewModelMock(state: .loading)
    let viewController = EpisodesListViewController(viewModel: initialState)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    // when
    let lightViewController = EpisodesListViewController(viewModel: initialState)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }

  func test_WhenViewModelDidPopulated_thenShow_PopulatedScreen() {
    // given
    let episodes = [
      TVShowEpisode.stub(id: 1, episodeNumber: 1, name: "Chapter 1"),
      TVShowEpisode.stub(id: 2, episodeNumber: 2, name: "Chapter 2"),
      TVShowEpisode.stub(id: 3, episodeNumber: 3, name: "Chapter 3")
    ]

    let initialState = EpisodesListViewModelMock(state: .populated,
                                                 numberOfSeasons: 3,
                                                 seasonSelected: 1,
                                                 episodes: episodes,
                                                 headerViewModel: headerViewModel)

    // when
    let viewController = EpisodesListViewController(viewModel: initialState)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    // when
    let lightViewController = EpisodesListViewController(viewModel: initialState)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }

  func test_WhenViewModelReturnsError_thenShow_ErrorScreen() {
    // given
    let initialState = EpisodesListViewModelMock(state: .error("Error to Fetch Show"))
    let viewController = EpisodesListViewController(viewModel: initialState)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    // when
    let lightViewController = EpisodesListViewController(viewModel: initialState)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }

  func test_WhenViewModelLoadSeason_thenShow_LoadingSeasonScreen() {
    // given
    let initialState = EpisodesListViewModelMock(state: .loadingSeason,
                                                 headerViewModel: headerViewModel)
    let viewController = EpisodesListViewController(viewModel: initialState)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    // when
    let lightViewController = EpisodesListViewController(viewModel: initialState)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }

  func test_WhenViewModelReturnsEmpty_thenShow_EmptyScreen() {
    // given
    let initialState = EpisodesListViewModelMock(state: .empty,
                                                 headerViewModel: headerViewModel)
    let viewController = EpisodesListViewController(viewModel: initialState)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    // when
    let lightViewController = EpisodesListViewController(viewModel: initialState)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }

  func test_WhenViewModelReturnsErrorSeason_thenShow_ErrorSeasonScreen() {
    // given
    let initialState = EpisodesListViewModelMock(state: .errorSeason(""),
                                                 headerViewModel: headerViewModel)
    let viewController = EpisodesListViewController(viewModel: initialState)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    // when
    let lightViewController = EpisodesListViewController(viewModel: initialState)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }
}
