//
//  AccountViewController.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import Shared

class AccountViewController: UIViewController, StoryboardInstantiable {
  
  private var viewModel: AccountViewModelProtocol!
  
  private var currentChildViewController: UIViewController?
  
  private var viewControllersFactory: AccountViewControllerFactory!
  
  static func create(with viewModel: AccountViewModelProtocol,
                     viewControllersFactory: AccountViewControllerFactory) -> AccountViewController {
    let controller = AccountViewController.instantiateViewController()
    controller.viewModel = viewModel
    controller.viewControllersFactory = viewControllersFactory
    return controller
  }
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    subscribe()
  }
  
  // MARK: - Setup UI
  
  fileprivate func subscribe() {
    viewModel
      .viewState
      .subscribe(onNext: { [weak self] viewState in
        self?.setupUI(with: viewState)
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func setupUI(with state: AccountViewState) {
    switch state {
    case .login:
      let loginVC = viewControllersFactory.makeSignInViewController()
      transition(to: loginVC, with: "Login")
    case .profile(let account):
      let profileVC = viewControllersFactory.makeProfileViewController(with: account)
      transition(to: profileVC, with: "Account")
    }
  }
  
  func transition(to viewController: UIViewController, with newTitle: String) {
    remove(asChildViewController: currentChildViewController)
    add(asChildViewController: viewController)
    title = newTitle
    currentChildViewController = viewController
  }
}

protocol AccountViewControllerFactory {
  func makeSignInViewController() -> UIViewController
  func makeProfileViewController(with account: AccountResult) -> UIViewController
}
