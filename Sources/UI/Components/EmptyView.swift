//
//  EmptyView.swift
//  Shared
//
//  Created by Jeans Ruiz on 8/3/20.
//

import UIKit

public class EmptyView: NiblessView {

  lazy var mainStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [imageView, messageLabel])
    stack.axis = .vertical
    stack.alignment = .center
    stack.distribution = .equalSpacing
    stack.spacing = 30.0
    return stack
  }()

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  public let messageLabel = UILabel(frame: .zero)

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  private func setupUI() {
    constructHierarchy()
    activateConstraints()
    configureViews()
  }

  private func configureViews() {
    backgroundColor = .systemBackground
    messageLabel.numberOfLines = 0
    imageView.image = UIImage(name: "empty.placeholder")
  }

  private func constructHierarchy() {
    addSubview(mainStackView)
  }

  private func activateConstraints() {
    activateConstraintsForStackView()
    activateConstraintsForImage()
  }

  private func activateConstraintsForStackView() {
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
      mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
      mainStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
    ])
  }

  private func activateConstraintsForImage() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 10/8)
    ])
  }
}
