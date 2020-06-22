//
//  ProfileViewController.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

class ProfileViewController: UIViewController, StoryboardInstantiable {
  
  private var viewModel: ProfileViewModel!
  
  static func create(with viewModel: ProfileViewModel) -> ProfileViewController {
    let controller = ProfileViewController.instantiateViewController(fromStoryBoard: "AccountViewController")
    controller.viewModel = viewModel
    return controller
  }
  
  @IBOutlet weak var mainLabel: UILabel!
  
  @IBOutlet weak var logoutButton: UIButton!
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("viewDidAppear ProfileViewController")
  }
  
  private func setupUI() {
    setupButton()
  }
  
  private func setupButton() {
    logoutButton.rx.tap.bind { [weak self] in
      self?.showSignOutActionSheet()
    }
    .disposed(by: disposeBag)
  }
  
  private func showSignOutActionSheet() {
    let signOutAction = UIAlertAction(title: "Sign out",
                                      style: .destructive) { [weak self] _ in
                                        self?.viewModel.input.tapLogoutAction.onNext(())
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
