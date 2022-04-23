//
//  AccountViewControllerFactoryMock.swift
//  AccountTests
//
//  Created by Jeans Ruiz on 20/12/21.
//

import UIKit
@testable import AccountFeature

class AccountViewControllerFactoryMock: AccountViewControllerFactory {
  func makeSignInViewController() -> UIViewController {
    let viewModel = SignInViewModelMock(state: .initial)
    return SignInViewController(viewModel: viewModel)
  }

  func makeProfileViewController(with account: AccountResult) -> UIViewController {
    let viewModel =  ProfileViewModelMock(account: account)
    return ProfileViewController(viewModel: viewModel)
  }
}

func configureWith(_ viewController: UIViewController, style: UIUserInterfaceStyle) {
  viewController.overrideUserInterfaceStyle = style
  _ = viewController.view
}
