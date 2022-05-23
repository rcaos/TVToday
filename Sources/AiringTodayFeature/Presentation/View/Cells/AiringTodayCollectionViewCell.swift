//
//  AiringTodayCollectionViewCell.swift
//  AiringToday
//
//  Created by Jeans on 10/2/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import Shared
import UI

class AiringTodayCollectionViewCell: NiblessCollectionViewCell {

  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .secondarySystemBackground
    view.layer.cornerRadius = 14
    view.clipsToBounds = true
    return view
  }()

  private let mainStackView: UIStackView = {
    let stack = UIStackView(frame: .zero)
    stack.axis = .vertical
    stack.alignment = .center
    stack.distribution = .fill
    stack.spacing = 0
    return stack
  }()

  private let backImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()

  private let nameStackView: UIStackView = {
    let stack = UIStackView(frame: .zero)
    stack.axis = .horizontal
    stack.alignment = .center
    stack.distribution = .fill
    stack.spacing = 0
    return stack
  }()

  private let averageStackView: UIStackView = {
    let stack = UIStackView(frame: .zero)
    stack.axis = .horizontal
    stack.alignment = .fill
    stack.distribution = .fill
    stack.spacing = 5
    return stack
  }()

  private let showNameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 3
    label.lineBreakMode = .byTruncatingTail
    label.adjustsFontForContentSizeCategory = true
    label.font = UIFont.app_title2().bolded
    return label
  }()

  private let starImageView: UIImageView = {
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .large)
    let starFill = UIImage(systemName: "star.fill", withConfiguration: largeConfig)

    let imageView = UIImageView()
    imageView.image = starFill
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = .systemYellow

    return imageView
  }()

  private let averageLabel = UILabel()

  private var viewModel: AiringTodayCollectionViewModel?

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  func setViewModel(_ viewModel: AiringTodayCollectionViewModel) {
    self.viewModel = viewModel
    showNameLabel.text = viewModel.showName
    averageLabel.text = viewModel.average
    backImageView.setImage(with: viewModel.posterURL)
  }

  override func prepareForReuse() {
    backImageView.image = nil
  }

  private func setupUI() {
    constructHierarchy()
    activateConstraints()
  }

  private func constructHierarchy() {
    mainStackView.addArrangedSubview(backImageView)

    nameStackView.addArrangedSubview(showNameLabel)

    averageStackView.addArrangedSubview(starImageView)
    averageStackView.addArrangedSubview(averageLabel)

    containerView.addSubview(mainStackView)
    containerView.addSubview(nameStackView)
    containerView.addSubview(averageStackView)

    contentView.addSubview(containerView)
  }

  private func activateConstraints() {
    activateConstraintsForAverageLabel()

    var allConstraints: [NSLayoutConstraint] = []
    allConstraints += activateConstraintsForContainerView()
    allConstraints += activateConstraintsForMainStackView()
    allConstraints += activateConstraintsForPosterImageView()
    allConstraints += activateConstraintsForNameStackView()
    allConstraints += activateConstraintsForAverageStackView()
    NSLayoutConstraint.activate(allConstraints)
  }

  private func activateConstraintsForNameStackView() -> [NSLayoutConstraint] {
    nameStackView.translatesAutoresizingMaskIntoConstraints = false
    return [
      nameStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
      nameStackView.trailingAnchor.constraint(equalTo: averageStackView.leadingAnchor, constant: -5),
      nameStackView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 10),
      nameStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
    ]
  }

  private func activateConstraintsForAverageStackView() -> [NSLayoutConstraint] {
    averageStackView.translatesAutoresizingMaskIntoConstraints = false
    return [
      averageStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
      averageStackView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 10)
    ]
  }

  private func activateConstraintsForContainerView() -> [NSLayoutConstraint] {
    containerView.translatesAutoresizingMaskIntoConstraints = false
    return [
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ]
  }

  private func activateConstraintsForMainStackView() -> [NSLayoutConstraint] {
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    return [
      mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
      mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
    ]
  }

  private func activateConstraintsForPosterImageView() -> [NSLayoutConstraint] {
    backImageView.translatesAutoresizingMaskIntoConstraints = false
    let aspectRatio = CGFloat(9.0 / 16.0)
    return [
      backImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: aspectRatio)
    ]
  }

  private func activateConstraintsForAverageLabel() {
    averageLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    averageLabel.setContentHuggingPriority(.required, for: .horizontal)

    showNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    showNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

    starImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
    starImageView.setContentHuggingPriority(.required, for: .horizontal)
  }
}
