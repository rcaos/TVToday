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
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let backImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let nameStackView: UIStackView = {
    let stack = UIStackView(frame: .zero)
    stack.axis = .horizontal
    stack.alignment = .center
    stack.distribution = .fill
    stack.spacing = 0
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()

  private let averageStackView: UIStackView = {
    let stack = UIStackView(frame: .zero)
    stack.axis = .horizontal
    stack.alignment = .fill
    stack.distribution = .fill
    stack.spacing = 5
    stack.translatesAutoresizingMaskIntoConstraints = false
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
    nameStackView.addArrangedSubview(showNameLabel)
    averageStackView.addArrangedSubview(starImageView)
    averageStackView.addArrangedSubview(averageLabel)

    containerView.addSubview(backImageView)
    containerView.addSubview(nameStackView)
    containerView.addSubview(averageStackView)

    contentView.addSubview(containerView)
  }

  private func activateConstraints() {
    setConstraintAttributes()

    var allConstraints: [NSLayoutConstraint] = []
    allConstraints += activateConstraintsForContainerView()
    allConstraints += activateConstraintsForBackImageView()
    allConstraints += activateConstraintsForPosterImageView()
    allConstraints += activateConstraintsForNameStackView()
    allConstraints += activateConstraintsForAverageStackView()
    NSLayoutConstraint.activate(allConstraints)
  }

  private func activateConstraintsForNameStackView() -> [NSLayoutConstraint] {
    return [
      nameStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
      nameStackView.trailingAnchor.constraint(equalTo: averageStackView.leadingAnchor, constant: -5),
      nameStackView.topAnchor.constraint(equalTo: backImageView.bottomAnchor, constant: 10),
      nameStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
    ]
  }

  private func activateConstraintsForAverageStackView() -> [NSLayoutConstraint] {
    return [
      averageStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
      averageStackView.topAnchor.constraint(equalTo: backImageView.bottomAnchor, constant: 10)
    ]
  }

  private func activateConstraintsForContainerView() -> [NSLayoutConstraint] {
    return [
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ]
  }

  private func activateConstraintsForBackImageView() -> [NSLayoutConstraint] {
    return [
      backImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
      backImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      backImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
    ]
  }

  private func activateConstraintsForPosterImageView() -> [NSLayoutConstraint] {
    let aspectRatio = CGFloat(9.0 / 16.0)
    return [
      backImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: aspectRatio)
    ]
  }

  private func setConstraintAttributes() {
    averageLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    averageLabel.setContentHuggingPriority(.required, for: .horizontal)

    showNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    showNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

    starImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
    starImageView.setContentHuggingPriority(.required, for: .horizontal)
  }
}
