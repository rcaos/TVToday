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

  private let nameLabel = TVBoldLabel(frame: .zero)

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
    let imageView = UIImageView()
    imageView.image = UIImage(name: "star")
    imageView.contentMode = .scaleAspectFit

    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalToConstant: 20),
      imageView.heightAnchor.constraint(equalToConstant: 20)
    ])
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
