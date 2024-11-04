//
//  Created by Jeans on 9/23/19.
//

import UIKit
import Combine
import CoreGraphics
import UI

class EpisodesListViewController: NiblessViewController, Loadable, Retryable {

  private let viewModel: EpisodesListViewModelProtocol

  private var rootView: EpisodesListRootView?

  private let loadingView = LoadingView(frame: .zero)
  private let emptyView = MessageImageView(message: "No episodes available", image: "tvshowEmpty")
  private let errorView = MessageImageView(message: "Unable to connect to server", image: "error.list.placeholder")

  private var disposeBag = Set<AnyCancellable>()

  // MARK: - Initializer
  init(viewModel: EpisodesListViewModelProtocol) {
    self.viewModel = viewModel
    super.init()
  }

  // MARK: - Life Cycle
  override func loadView() {
    rootView = EpisodesListRootView(viewModel: viewModel)
    view = rootView

    loadingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
    emptyView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
    errorView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    subscribeToViewState()

    Task {
      await viewModel.viewDidLoad()
    }
  }

  deinit {
    print("deinit \(Self.self)")
  }

  private func subscribeToViewState() {
    viewModel
      .viewState
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] state in
        self?.configureView(with: state)
      })
      .store(in: &disposeBag)
  }

  private func configureView(with state: EpisodesListViewModel.ViewState) {

    switch state {
    case .loading :
      showLoadingView()
      rootView?.tableView.tableFooterView = nil
      rootView?.tableView.separatorStyle = .none
      hideMessageView()

    case .populated :
      hideLoadingView()
      rootView?.tableView.tableFooterView = UIView()
      rootView?.tableView.separatorStyle = .none
      hideMessageView()

    case .loadingSeason:
      hideLoadingView()
      rootView?.tableView.tableFooterView = loadingView
      rootView?.tableView.separatorStyle = .none
      hideMessageView()

    case .empty :
      hideLoadingView()
      rootView?.tableView.tableFooterView = emptyView
      rootView?.tableView.separatorStyle = .none

    case .error(let message):
      hideLoadingView()
      rootView?.tableView.tableFooterView = nil
      rootView?.tableView.separatorStyle = .none
      showMessageView(with: message,
                      errorHandler: { [weak self] in
        Task {
          await self?.viewModel.refreshView()
        }
      })

    case .errorSeason:
      hideLoadingView()
      rootView?.tableView.tableFooterView = errorView
      rootView?.tableView.separatorStyle = .none
      hideMessageView()
    }
  }
}
