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
import Shared

class SignInViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var tvImageView: UIImageView!
  @IBOutlet weak var signInButton: LoadableButton!
  
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
    
    setupImage()
    setupButton()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  fileprivate func setupImage() {
    tvImageView.image = UIImage(name: "newTV")
  }
  
  fileprivate func setupButton() {
    signInButton.setBackgroundImage(UIImage(name: "loginbackground"), for: .normal)
    signInButton.defaultTitle = "Sign in with TheMovieDB"
    
    signInButton.rx
      .tap
      .bind(to: viewModel.input.tapButton)
      .disposed(by: disposeBag)
    
    viewModel.output
      .viewState
      .subscribe(onNext: { [weak self] state in
        self?.setupView(with: state)
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func setupView(with state: SignInViewModel.ViewState) {
    switch state {
    case .initial:
      signInButton.defaultHideLoadingView()
    case .loading:
      signInButton.defaultShowLoadingView()
    }
  }
}
