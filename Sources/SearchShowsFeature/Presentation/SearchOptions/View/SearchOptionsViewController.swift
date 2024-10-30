//
//  Created by Jeans Ruiz on 7/7/20.
//

import UIKit
import Combine
import UI

class SearchOptionsViewController: NiblessViewController, Loadable {
  private let viewModel: SearchOptionsViewModelProtocol
  private var rootView: SearchOptionRootView?
  private let messageView = MessageView(frame: .zero)
  private var disposeBag = Set<AnyCancellable>()

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

    Task {
      await viewModel.viewDidLoad()
    }
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
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] viewState in
        self?.handleTableState(with: viewState)
      })
      .store(in: &disposeBag)
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
