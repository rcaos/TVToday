//
//  Created by Jeans Ruiz on 6/19/20.
//

import Foundation
import Combine
import UI

class SignInViewController: NiblessViewController {
  private let viewModel: SignInViewModelProtocol
  private var rootView: SignInRootView?
  private var disposeBag = Set<AnyCancellable>()

  init(viewModel: SignInViewModelProtocol) {
    self.viewModel = viewModel
    super.init()
  }

  // MARK: - Lifecycle
  override func loadView() {
    rootView = SignInRootView(viewModel: viewModel)
    view = rootView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    subscribe()
  }

  fileprivate func subscribe() {
    viewModel
      .viewState
      .receive(on: defaultScheduler)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] state in
        self?.setupView(with: state)
      })
      .store(in: &disposeBag)
  }

  fileprivate func setupView(with state: SignInViewState) {
    switch state {
    case .initial:
      rootView?.signInButton.defaultHideLoadingView()
    case .loading:
      rootView?.signInButton.defaultShowLoadingView()
    case .error:
      rootView?.signInButton.defaultHideLoadingView()
    }
  }
}
