//
//  TVShowViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

public class TVShowViewCell: NiblessTableViewCell {

  private let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(name: "newTV")
    imageView.contentMode = .scaleAspectFit
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
    stack.distribution = .fillEqually
    stack.spacing = 5
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

  public func setModel(viewModel: TVShowCellViewModel) {
    posterImageView.setImage(with: viewModel.posterPathURL)
    nameLabel.text = viewModel.name
    startYearLabel.text = viewModel.firstAirDate
    averageLabel.text = viewModel.average
  }

  private func constructHierarchy() {
    contentView.addSubview(posterImageView)
  }

  private func activateConstraints() {
    activateConstraintsForPosterView()
    activateConstraintsForLeftStackView()
  }

  private func activateConstraintsForPosterView() {
    posterImageView.translatesAutoresizingMaskIntoConstraints = false
    posterImageView.setContentCompressionResistancePriority(.required, for: .vertical)

    NSLayoutConstraint.activate([
      posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      posterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
      posterImageView.heightAnchor.constraint(equalToConstant: 150)
    ])
  }

  private func activateConstraintsForLeftStackView() {
  }
}
