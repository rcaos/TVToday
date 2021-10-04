//
//  SignInRootView.swift
//  AccountTV
//
//  Created by Jeans Ruiz on 8/21/20.
//

import UIKit
import Shared
import RxSwift

class SignInRootView: NiblessView {

  private let viewModel: SignInViewModelProtocol

  private let disposeBag = DisposeBag()

  let signInButton: LoadableButton = {
    let button = LoadableButton(type: .custom)
    button.setBackgroundImage(UIImage(name: "loginbackground"), for: .normal)
    button.defaultTitle = "Sign in with TheMovieDB"
    button.titleLabel?.font = .boldSystemFont(ofSize: 20)
    button.heightAnchor.constraint(equalToConstant: 65).isActive = true
    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    return button
  }()

  private let tvImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(name: "newTV")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  lazy var mainStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [tvImageView, signInButton])
    stack.axis = .vertical
    stack.alignment = .center
    stack.distribution = .equalSpacing
    stack.spacing = 30.0
    return stack
  }()

  // MARK: - Initializer
  init(frame: CGRect = .zero, viewModel: SignInViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)

    backgroundColor = .white
    setupBindables()
    constructHierarchy()
  }

  fileprivate func setupBindables() {
    signInButton.rx
      .tap
      .bind(to: viewModel.tapButton)
      .disposed(by: disposeBag)
  }

  fileprivate func constructHierarchy() {
    addSubview(mainStackView)
    activateConstraints()
  }

  fileprivate func activateConstraints() {
    mainStackView.translatesAutoresizingMaskIntoConstraints = false

    let centerX = mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
    let proportionalWidth = mainStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7)

    let centerY = mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40)
    let proportionalHeight = mainStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4)

    NSLayoutConstraint.activate([centerX, proportionalWidth, centerY, proportionalHeight])
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
