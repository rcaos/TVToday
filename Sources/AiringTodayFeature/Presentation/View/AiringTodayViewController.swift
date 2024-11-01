//
//  Created by Jeans on 8/21/19.
//

import UIKit
import Combine
import Shared
import UI

class AiringTodayViewController: NiblessViewController, Loadable, Retryable, Emptiable {

  private let viewModel: AiringTodayViewModelProtocol
  private var disposeBag = Set<AnyCancellable>()
  private var rootView: (AiringTodayRootViewProtocol & UIView)?

  init(viewModel: AiringTodayViewModelProtocol) {
    self.viewModel = viewModel
    super.init()
  }

  // MARK: - Life Cycle
  override func loadView() {
    rootView = AiringTodayRootViewCompositional(viewModel: viewModel)
    view = rootView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    subscribeToViewState()

    Task {
      await viewModel.viewDidLoad()
    }
  }

  private func subscribeToViewState() {
    viewModel
      .viewStateObservableSubject
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] viewstate in
        self?.handleViewState(with: viewstate)
      })
      .store(in: &disposeBag)
  }

  private func handleViewState(with state: SimpleViewState<AiringTodayCollectionViewModel>) {
    stopRefresh()

    switch state {
    case .loading:
      showLoadingView()
      hideMessageView()

    case .empty:
      hideLoadingView()
      showEmptyView(with: Strings.commonEmptyTitle.localized())

    case .error(let message):
      hideLoadingView()
      showMessageView(
        with: message,
        errorHandler: { [weak self] in
          Task {
            await self?.viewModel.refreshView()
          }
      })

    default:
      hideLoadingView()
      hideMessageView()
    }
  }

  private func stopRefresh() {
    rootView?.stopRefresh()
  }
}
