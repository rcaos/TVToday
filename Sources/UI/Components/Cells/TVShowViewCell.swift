//
//  TVShowViewCell.swift
//  UI
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

public class TVShowViewCell: NiblessTableViewCell {

  private let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.setContentCompressionResistancePriority(.required, for: .vertical)
    return imageView
  }()

  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.app_title3().bolded
    label.adjustsFontForContentSizeCategory = true
    return label
  }()

  private let startYearLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.numberOfLines = 0
    label.font = UIFont.app_body()
    label.adjustsFontForContentSizeCategory = true
    return label
  }()

  private lazy var rightContainerStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [nameLabel, startYearLabel, averageStackView])
    stack.axis = .vertical
    stack.alignment = .leading
    stack.distribution = .fill
    stack.spacing = 5
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()

  private let starImageView: UIImageView = {
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large)
    let starFill = UIImage(systemName: "star.fill", withConfiguration: largeConfig)

    let imageView = UIImageView()
    imageView.image = starFill
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = .systemYellow
    return imageView
  }()

  private let averageLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.numberOfLines = 0
    label.font = UIFont.app_body()
    label.adjustsFontForContentSizeCategory = true
    return label
  }()

  private lazy var averageStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [starImageView, averageLabel])
    stack.axis = .horizontal
    stack.alignment = .fill
    stack.distribution = .fill
    stack.spacing = 5.0
    return stack
  }()

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  private func setupUI() {
    backgroundColor = .secondarySystemBackground
    constructHierarchy()
    activateConstraints()
  }

  private func constructHierarchy() {
    contentView.addSubview(posterImageView)
    contentView.addSubview(rightContainerStackView)
  }

  private func activateConstraints() {
    var constraints = [NSLayoutConstraint]()
    constraints.append(contentsOf: activateConstraintsForPosterView())
    constraints.append(contentsOf: activateConstraintsForLeftStackView())
    NSLayoutConstraint.activate(constraints)
  }

  private func activateConstraintsForPosterView() -> [NSLayoutConstraint] {
    return [
      posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      posterImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
      posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      posterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
      posterImageView.heightAnchor.constraint(equalToConstant: 150)
    ]
  }

  private func activateConstraintsForLeftStackView() -> [NSLayoutConstraint] {
    let centerConstraint = rightContainerStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    centerConstraint.priority = .defaultHigh
    return [
      rightContainerStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 8),
      rightContainerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      rightContainerStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
      rightContainerStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
      centerConstraint
    ]
  }

  // MARK: - Public
  public func setModel(viewModel: TVShowCellViewModel) {
    posterImageView.setImage(with: viewModel.posterPathURL)
    nameLabel.text = viewModel.name
    startYearLabel.text = viewModel.firstAirDate
    averageLabel.text = viewModel.average
  }
}
