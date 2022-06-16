//
//  AccountViewController.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import Combine
import UI

class AccountViewController: NiblessViewController {

  private let viewModel: AccountViewModelProtocol
  private let viewControllersFactory: AccountViewControllerFactory
  private var currentChildViewController: UIViewController?
  private var disposeBag = Set<AnyCancellable>()

  init(viewModel: AccountViewModelProtocol, viewControllersFactory: AccountViewControllerFactory) {
    self.viewModel = viewModel
    self.viewControllersFactory = viewControllersFactory
    super.init()
  }

  // MARK: - Life Cycle
  override func loadView() {
    view = UIView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.viewDidLoad()
    subscribe()
  }

  // MARK: - Setup UI
  private func subscribe() {
    viewModel
      .viewState
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] viewState in
        self?.setupUI(with: viewState)
      })
      .store(in: &disposeBag)
  }

  private func setupUI(with state: AccountViewState) {
    switch state {
    case .login:
      let loginVC = viewControllersFactory.makeSignInViewController()
      transition(to: loginVC, with: Strings.accountTitleLogin.localized())
    case .profile(let account):
      let profileVC = viewControllersFactory.makeProfileViewController(with: account)
      transition(to: profileVC, with: Strings.accountTitle.localized())
    }
  }

  private func transition(to viewController: UIViewController, with newTitle: String) {
    remove(asChildViewController: currentChildViewController)
    add(asChildViewController: viewController)
    title = newTitle
    currentChildViewController = viewController
  }
}

// MARK: - AccountViewControllerFactory
protocol AccountViewControllerFactory {
  func makeSignInViewController() -> UIViewController
  func makeProfileViewController(with account: Account) -> UIViewController
}
