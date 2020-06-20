//
//  AccountViewController.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, StoryboardInstantiable {
  
  private var viewModel: AccountViewModel!
  
  private var signInViewController: SignInViewController!
  
  private var profileViewController: ProfileViewController!
  
  static func create(with viewModel: AccountViewModel,
                     signInViewController: SignInViewController,
                     profileViewController: ProfileViewController) -> AccountViewController {
    let controller = AccountViewController.instantiateViewController()
    controller.viewModel = viewModel
    controller.signInViewController = signInViewController
    controller.profileViewController = profileViewController
    return controller
  }
  
  private var viewState: ViewState = .login
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .cyan
    
    setupUI()
  }
  
  // MARK: - Setup UI
  
  func setupUI() {
    switch viewState {
    case .login:
      add(asChildViewController: signInViewController)
      
    case .profile:
      break
    }
  }
  
  func setupViews() {
    
  }
}

extension AccountViewController {
  
  private enum ViewState {
    case login,
    
    profile
  }
  
}
