//
//  TVShowViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import UI

public class TVShowViewCell: NiblessTableViewCell {

  private let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(name: "newTV")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private lazy var nameLabel: TVBoldLabel = {
    let label = TVBoldLabel(frame: .zero)
    label.numberOfLines = 0
    return label
  }()

  private let startYearLabel = TVRegularLabel(frame: .zero)

  private lazy var rightContainerStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [nameLabel, startYearLabel, averageStackView])
    stack.axis = .vertical
    stack.alignment = .leading
    stack.distribution = .fill
    stack.spacing = 8.0
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

  private let averageLabel = TVRegularLabel(frame: .zero)

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
    addSubview(posterImageView)
    addSubview(rightContainerStackView)
  }

  private func activateConstraints() {
    activateConstraintsForPosterView()
    activateConstraintsForLeftStackView()
  }

  private func activateConstraintsForPosterView() {
    posterImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      posterImageView.trailingAnchor.constraint(equalTo: rightContainerStackView.leadingAnchor, constant: -8),
      posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
      posterImageView.widthAnchor.constraint(equalToConstant: 150)
    ])
  }

  private func activateConstraintsForLeftStackView() {
    rightContainerStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      rightContainerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
      rightContainerStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}
