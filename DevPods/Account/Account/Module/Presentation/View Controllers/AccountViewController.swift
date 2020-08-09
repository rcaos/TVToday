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
  
  private var signInViewController: SignInViewController!
  
  private var profileViewController: ProfileViewController!
  
  static func create(with viewModel: AccountViewModelProtocol,
                     signInViewController: SignInViewController,
                     profileViewController: ProfileViewController) -> AccountViewController {
    let controller = AccountViewController.instantiateViewController()
    controller.viewModel = viewModel
    controller.signInViewController = signInViewController
    controller.profileViewController = profileViewController
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
      remove(asChildViewController: profileViewController)
      add(asChildViewController: signInViewController)
      title = "Login"
    case .profile:
      remove(asChildViewController: signInViewController)
      add(asChildViewController: profileViewController)
      title = "Account"
    }
  }
}
