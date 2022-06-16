//
//  ProfileViewController.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import Combine
import UI

class ProfileViewController: NiblessViewController {

  private let viewModel: ProfileViewModelProtocol
  private var disposeBag = Set<AnyCancellable>()

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

  private func setupBindables() {
    viewModel
      .presentSignOutAlert
      .filter { $0 == true }
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
        self?.showSignOutActionSheet()
      })
      .store(in: &disposeBag)
  }

  private func showSignOutActionSheet() {
    let signOutAction = UIAlertAction(title: Strings.accountAlertLogout.localized(),
                                      style: .destructive) { [weak self] _ in
      self?.viewModel.didTapLogoutButton()
    }

    let actionSheet = UIAlertController(title: Strings.accountAlertTitle.localized(),
                                        message: nil,
                                        preferredStyle: .actionSheet)
    let cancelTitle = Strings.accountAlertCancel.localized()
    let cancelActionButton = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
      self.dismiss(animated: true)
    }
    actionSheet.addAction(cancelActionButton)
    actionSheet.addAction(signOutAction)
    present(actionSheet, animated: true, completion: nil)
  }
}
