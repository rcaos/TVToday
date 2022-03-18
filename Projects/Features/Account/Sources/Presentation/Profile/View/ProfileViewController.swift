//
//  ProfileViewController.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import Shared

class ProfileViewController: NiblessViewController {

  private let viewModel: ProfileViewModelProtocol
  private let disposeBag = DisposeBag()

  init(viewModel: ProfileViewModelProtocol) {
    self.viewModel = viewModel
    super.init()
  }

  // MARK: - Life Cycle
  override func loadView() {
    view = ProfileRootView(viewModel: viewModel)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupBindables()
  }

  fileprivate func setupBindables() {
    viewModel
      .presentSignOutAlert
      .filter { $0 == true }
      .subscribe(onNext: { [weak self] _ in
        self?.showSignOutActionSheet()
      })
      .disposed(by: disposeBag)
  }

  fileprivate func showSignOutActionSheet() {
    let signOutAction = UIAlertAction(title: "Sign out",
                                      style: .destructive) { [weak self] _ in
                                        self?.viewModel.didTapLogoutButton()
    }

    let actionSheet = UIAlertController(title: "Are you sure you want to Sign out?",
                                        message: nil,
                                        preferredStyle: .actionSheet)
    let cancelTitle = "Cancel"
    let cancelActionButton = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
      self.dismiss(animated: true)
    }
    actionSheet.addAction(cancelActionButton)
    actionSheet.addAction(signOutAction)
    present(actionSheet, animated: true, completion: nil)
  }
}
