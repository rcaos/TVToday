//
//  AccountViewControllerFactoryMock.swift
//  AccountTests
//
//  Created by Jeans Ruiz on 20/12/21.
//

import UIKit
@testable import Account

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
