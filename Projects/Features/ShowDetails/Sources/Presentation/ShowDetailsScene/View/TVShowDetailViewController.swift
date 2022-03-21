//
//  TVShowDetailViewController.swift
//  ShowDetails
//
//  Created by Jeans Ruiz on 8/21/20.
//

import UIKit
import RxSwift
import Shared
import UI

class TVShowDetailViewController: NiblessViewController, Loadable, Retryable, Emptiable {

  let viewModel: TVShowDetailViewModelProtocol

  var rootView: TVShowDetailRootView?

  lazy var favoriteButton: UIBarButtonItem = {
    let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"),
                                        style: .plain, target: nil, action: nil)
    return barButtonItem
  }()

  lazy var watchListButton: UIBarButtonItem = {
    let bookmarkButton = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"),
                                         style: .plain, target: nil, action: nil)
    return bookmarkButton
  }()

  let disposeBag = DisposeBag()

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
    favoriteButton.primaryAction = UIAction(handler: { [weak self] _ in
      self?.viewModel.tapFavoriteButton.send(())
    })

    watchListButton.primaryAction = UIAction(handler: { [weak self] _ in
      self?.viewModel.tapWatchedButton.onNext(())
    })

    viewModel
      .isFavorite
      .subscribe(onNext: { [weak self] isFavorite in
        self?.favoriteButton.tintColor = isFavorite ? .systemRed : .systemGray
      })
      .disposed(by: disposeBag)

    viewModel
      .isWatchList
      .subscribe(onNext: { [weak self] isWatchList in
        self?.watchListButton.tintColor = isWatchList ? .systemGreen : .systemGray
      })
      .disposed(by: disposeBag)
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
