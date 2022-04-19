//
//  AuthPermissionViewController.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import Shared

class AuthPermissionViewController: NiblessViewController {

  private let viewModel: AuthPermissionViewModelProtocol
  private var rootView: AuthPermissionRootView?

  init(viewModel: AuthPermissionViewModelProtocol) {
    self.viewModel = viewModel
    super.init()
  }

  // MARK: - Life Cycle
  override func loadView() {
    rootView = AuthPermissionRootView(viewModel: viewModel)
    view = rootView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    loadURL()
  }

  deinit {
    print("deinit \(Self.self)")
  }

  fileprivate func loadURL() {
    rootView?.loadURL()
  }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension AuthPermissionViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    viewModel.signIn()
  }
}
