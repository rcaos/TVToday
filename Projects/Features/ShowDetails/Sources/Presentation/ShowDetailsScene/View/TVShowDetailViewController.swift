//
//  TVShowDetailViewController.swift
//  ShowDetails
//
//  Created by Jeans Ruiz on 8/21/20.
//

import UIKit
import Combine
import RxSwift
import Shared
import UI

class TVShowDetailViewController: NiblessViewController, Loadable, Retryable, Emptiable {

  private let viewModel: TVShowDetailViewModelProtocol

  private var rootView: TVShowDetailRootView?

  private lazy var favoriteButton: UIBarButtonItem = {
    return UIBarButtonItem()
  }()

  private lazy var watchListButton: UIBarButtonItem = {
    return UIBarButtonItem()
  }()

  private let disposeBag = DisposeBag()

  private var cancelables = Set<AnyCancellable>()

  // MARK: - Initializer
  init(viewModel: TVShowDetailViewModelProtocol) {
    self.viewModel = viewModel
    super.init()
  }

  override func loadView() {
    rootView = TVShowDetailRootView(viewModel: viewModel)
    view = rootView
  }

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    setupNavigationBar()
    setupViewModel()
    viewModel.viewDidLoad()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }

  deinit {
    viewModel.viewDidFinish()
    print("deinit \(Self.self)")
  }

  fileprivate func setupNavigationBar() {
    if viewModel.isUserLogged() {
      navigationItem.rightBarButtonItems = [favoriteButton, watchListButton]
    } else {
      navigationItem.rightBarButtonItems = []
    }
  }

  fileprivate func setupViewModel() {
    setupBindables()
  }

  fileprivate func setupBindables() {
    if viewModel.isUserLogged() {
      setupBindablesForUserLogged()
    }

    viewModel.viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.configView(with: state)
      })
      .disposed(by: disposeBag)
  }

  private func setupBindablesForUserLogged() {
    favoriteButton.primaryAction = UIAction(
      image: UIImage(systemName: "heart.fill"),
      handler: { [weak self] _ in
        self?.viewModel.favoriteButtonDidTapped()
      })

    watchListButton.primaryAction = UIAction(
      image: UIImage(systemName: "bookmark.fill"),
      handler: { [weak self] _ in
        self?.viewModel.watchedButtonDidTapped()
      })

    viewModel
      .isFavorite
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in },
            receiveValue: { [weak self] isFavorite in
        self?.favoriteButton.tintColor = isFavorite ? .systemRed : .systemGray
      })
      .store(in: &cancelables)

    viewModel
      .isWatchList
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in },
            receiveValue: { [weak self] isWatchList in
        self?.watchListButton.tintColor = isWatchList ? .systemGreen : .systemGray
      })
      .store(in: &cancelables)
  }

  fileprivate func configView(with state: TVShowDetailViewModel.ViewState) {
    switch state {
    case .loading:
      showLoadingView()
      hideMessageView()

    case .populated(let tvShowDetail):
      hideLoadingView()
      hideMessageView()

      rootView?.setupView(with: tvShowDetail)

    case .error(let message):
      hideLoadingView()
      showMessageView(with: message,
                      errorHandler: { [weak self] in
                        self?.viewModel.refreshView()
      })
    }
  }
}
