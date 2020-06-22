//
//  SignInViewController.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var signInButton: UIButton!
  
  private var viewModel: SignInViewModel!
  
  private let disposeBag = DisposeBag()
  
  static func create(with viewModel: SignInViewModel) -> SignInViewController {
    let controller = SignInViewController.instantiateViewController(fromStoryBoard: "AccountViewController")
    controller.viewModel = viewModel
    return controller
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupButton()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("viewDidAppear SignInViewController")
  }
  
  fileprivate func setupButton() {
    signInButton.rx
      .tap
      .bind(to: viewModel.input.tapButton)
      .disposed(by: disposeBag)
  }
}
