//
//  TVShowListViewController.swift
//  MyTvShows
//
//  Created by Jeans on 8/26/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Shared

class TVShowListViewController: NiblessViewController, Loadable, Retryable, Emptiable {

  private let viewModel: TVShowListViewModelProtocol
  private var rootView: TVShowListRootView?
  private let disposeBag = DisposeBag()

  init(viewModel: TVShowListViewModelProtocol) {
    self.viewModel = viewModel
    super.init()
  }

  // MARK: - Life Cycle
  override func loadView() {
    rootView = TVShowListRootView(viewModel: viewModel)
    view = rootView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    subscribeToViewState()
    viewModel.viewDidLoad()
  }

  deinit {
    viewModel.viewDidFinish()
    print("deinit \(Self.self)")
  }

  fileprivate func subscribeToViewState() {
    viewModel
      .viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.configView(with: state)
      })
      .disposed(by: disposeBag)
  }

  fileprivate func configView(with state: SimpleViewState<TVShowCellViewModel>) {

    rootView?.tableView.refreshControl?.endRefreshing(with: 0.5)

    switch state {
    case .loading:
      showLoadingView()
      rootView?.tableView.tableFooterView = nil
      rootView?.tableView.separatorStyle = .none
      hideMessageView()

    case .paging :
      hideLoadingView()
      rootView?.tableView.tableFooterView = LoadingView.defaultView
      rootView?.tableView.separatorStyle = .singleLine
      hideMessageView()

    case .populated :
      hideLoadingView()
      rootView?.tableView.tableFooterView = UIView()
      rootView?.tableView.separatorStyle = .singleLine
      hideMessageView()

    case .empty:
      hideLoadingView()
      rootView?.tableView.tableFooterView = nil
      rootView?.tableView.separatorStyle = .none
      showEmptyView(with: "No TvShow to see")

    case .error(let message):
      hideLoadingView()
      rootView?.tableView.tableFooterView = UIView()
      rootView?.tableView.separatorStyle = .none
      showMessageView(with: message,
                      errorHandler: { [weak self] in
                        self?.viewModel.refreshView()
      })
    }
  }
}
