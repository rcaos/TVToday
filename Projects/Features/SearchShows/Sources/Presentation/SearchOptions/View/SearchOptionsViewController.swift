//
//  SearchOptionsViewController.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/7/20.
//

import UIKit
import RxSwift
import Shared

class SearchOptionsViewController: NiblessViewController, Loadable {
  private let viewModel: SearchOptionsViewModelProtocol

  private var rootView: SearchOptionRootView?

  private let messageView = MessageView(frame: .zero)

  private let disposeBag = DisposeBag()

  init(viewModel: SearchOptionsViewModelProtocol) {
    self.viewModel = viewModel
    super.init()
  }

  // MARK: - Life Cycle
  override func loadView() {
    rootView = SearchOptionRootView(viewModel: viewModel)
    view = rootView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    viewModel.viewDidLoad()
  }

  private func setupUI() {
    setupViews()
    bindViewState()
  }

  private func setupViews() {
    messageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
  }

  private func bindViewState() {
    viewModel.viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.handleTableState(with: state)
      })
      .disposed(by: disposeBag)
  }

  private func handleTableState(with state: SearchViewState) {
    hideLoadingView()

    switch state {
    case .loading:
      showLoadingView()
      rootView?.tableView.tableFooterView = nil
      rootView?.tableView.separatorStyle = .none

    case .populated:
      rootView?.tableView.tableFooterView = nil
      rootView?.tableView.separatorStyle = .singleLine

    case .empty:
      messageView.messageLabel.text = "No genres to Show"
      rootView?.tableView.tableFooterView = messageView
      rootView?.tableView.separatorStyle = .none

    case .error(let message):
      messageView.messageLabel.text = message
      rootView?.tableView.tableFooterView = messageView
      rootView?.tableView.separatorStyle = .none
    }
  }
}
