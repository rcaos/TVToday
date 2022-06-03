//
//  SignInRootView.swift
//  AccountTV
//
//  Created by Jeans Ruiz on 8/21/20.
//

import UIKit
import UI

class SignInRootView: NiblessView {

  private let viewModel: SignInViewModelProtocol

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

  private lazy var mainStackView: UIStackView = {
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

    backgroundColor = .secondarySystemBackground
    setupBindables()
    constructHierarchy()
  }

  private func setupBindables() {
    signInButton.addAction(
      UIAction(handler: { [viewModel] _ in
        viewModel.signInDidTapped()
      }),
      for: .touchUpInside
    )
  }

  private func constructHierarchy() {
    addSubview(mainStackView)
    activateConstraints()
  }

  private func activateConstraints() {
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
      mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40),
      mainStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4)
    ]
    )
  }
}
