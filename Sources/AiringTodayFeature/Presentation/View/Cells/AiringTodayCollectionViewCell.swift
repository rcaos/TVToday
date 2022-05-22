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
      bottomStackView
    ])
    stack.axis = .vertical
    stack.alignment = .fill
    stack.distribution = .fill
    stack.spacing = 0
    return stack
  }()

  private let backImageView: UIImageView = {
    let imageView = UIImageView()
    //imageView.contentMode = .scaleToFill
    //imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()

  private lazy var bottomStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [
      showNameLabel,
//      starImageView,
      averageLabel
    ])
    stack.axis = .horizontal
    stack.alignment = .center
    stack.distribution = .fill
    stack.spacing = 5
    stack.isLayoutMarginsRelativeArrangement = true
    stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    return stack
  }()

  private let showNameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 3
    label.lineBreakMode = .byTruncatingTail
    label.adjustsFontForContentSizeCategory = true
    label.font = UIFont.app_title3().bolded
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
    containerView.addSubview(mainStackView)
    contentView.addSubview(containerView)
  }

  private func activateConstraints() {
    activateConstraintsForContainerView()
    activateConstraintsForMainStackView()
    activateConstraintsForPosterImageView()
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
//      //backImageView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.8)
//      backImageView.heightAnchor.constraint(equalToConstant: 125)
//    ])
  }

  private func activateConstraintsForAverageLabel() {
    averageLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    averageLabel.setContentHuggingPriority(.required, for: .horizontal)

    showNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    showNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
//    starImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
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
