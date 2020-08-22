//
//  SignInViewController.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import Shared

class SignInViewController: NiblessViewController {
  
  private let viewModel: SignInViewModelProtocol
  
  private var rootView: SignInRootView?
  
  private let disposeBag = DisposeBag()
  
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
      .subscribe(onNext: { [weak self] state in
        self?.setupView(with: state)
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func setupView(with state: SignInViewState) {
    switch state {
    case .initial:
      rootView?.signInButton.defaultHideLoadingView()
    case .loading:
      rootView?.signInButton.defaultShowLoadingView()
    case .error:
      rootView?.signInButton.defaultHideLoadingView()
      // MARK: - TODO, show a label with error or something
    }
  }
}
