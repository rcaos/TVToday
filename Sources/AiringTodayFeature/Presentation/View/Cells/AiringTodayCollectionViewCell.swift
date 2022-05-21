//
//  AiringTodayCollectionViewCell.swift
//  MyTvShows
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

  private lazy var mainStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [
      //backImageView,
      bottomView])
    stack.axis = .vertical
    stack.alignment = .fill
    stack.distribution = .fill
    stack.spacing = 0
    return stack
  }()

  private let backImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleToFill
    imageView.clipsToBounds = true
    return imageView
  }()

  private let bottomView = UIView()

  private let showNameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 3
    label.lineBreakMode = .byTruncatingTail
    label.adjustsFontForContentSizeCategory = true
    label.font = UIFont.app_title3().bolded
    return label
  }()

  private lazy var bottomRightStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [
      starImageView,
      averageLabel])
    stack.axis = .horizontal
    stack.alignment = .center
    stack.distribution = .fill
    stack.spacing = 5
    return stack
  }()

  private let starImageView: UIImageView = {
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .large)
    let starFill = UIImage(systemName: "star.fill", withConfiguration: largeConfig)

    let imageView = UIImageView()
    imageView.image = starFill
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = .systemYellow

    imageView.setContentCompressionResistancePriority(.required, for: .horizontal)

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
    bottomView.addSubview(showNameLabel)
    bottomView.addSubview(bottomRightStackView)
    containerView.addSubview(mainStackView)
    contentView.addSubview(containerView)
  }

  private func activateConstraints() {
    activateConstraintsForContainerView()
    activateConstraintsForMainStackView()
    activateConstraintsForPosterImageView()
    activateConstraintsForBottomRightStackView()
    activateConstraintsForNameShow()
    activateConstraintsForAverageLabel()
  }

  private func activateConstraintsForContainerView() {
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.pin(to: contentView, insets: .init(top: 8, left: 8, bottom: 0, right: 8))
  }

  private func activateConstraintsForMainStackView() {
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.pin(to: containerView)
  }

  private func activateConstraintsForPosterImageView() {
//    backImageView.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//      backImageView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.8)
//    ])
  }

  private func activateConstraintsForBottomRightStackView() {
    bottomRightStackView.translatesAutoresizingMaskIntoConstraints = false
    bottomRightStackView.setContentCompressionResistancePriority(.required, for: .horizontal)
    NSLayoutConstraint.activate([
      bottomRightStackView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -8)
    ])
  }

  private func activateConstraintsForNameShow() {
    showNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      showNameLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 8),
      showNameLabel.trailingAnchor.constraint(equalTo: bottomRightStackView.leadingAnchor, constant: -8),
      showNameLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 8),
      showNameLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -8)
    ])
  }

  private func activateConstraintsForAverageLabel() {
    averageLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    averageLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

    averageLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      averageLabel.firstBaselineAnchor.constraint(equalTo: showNameLabel.firstBaselineAnchor)
    ])
  }

  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    setNeedsLayout()
    layoutIfNeeded()
    let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
    var newFrame = layoutAttributes.frame
    newFrame.size.height = ceil(size.height)  // note: don't change the width
    layoutAttributes.frame = newFrame
    return layoutAttributes
  }
}
