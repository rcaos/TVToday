//
//  EpisodeItemTableViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import Shared
import UI

class EpisodeItemTableViewCell: NiblessTableViewCell {

  private let separatorView = UIView()

  private let episodeImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(name: "placeholder")
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private lazy var episodeNameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.app_title3().bolded
    label.adjustsFontForContentSizeCategory = true
    return label
  }()

  private let releaseLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.numberOfLines = 0
    label.font = UIFont.app_body()
    label.adjustsFontForContentSizeCategory = true
    return label
  }()

  private lazy var rightContainerStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [episodeNameLabel, releaseLabel, averageStackView])
    stack.axis = .vertical
    stack.alignment = .leading
    stack.distribution = .fill
    stack.spacing = 8.0
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

  private var viewModel: EpisodeItemViewModel?

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  func setModel(viewModel: EpisodeItemViewModel) {
    self.viewModel = viewModel

    let episodeNumber = viewModel.episodeNumber ?? ""
    let episodeName = viewModel.episodeName ?? ""
    episodeNameLabel.text = "\(episodeNumber) \(episodeName)"
    releaseLabel.text = viewModel.releaseDate
    averageLabel.text = viewModel.average
    episodeImageView.setImage(with: viewModel.posterURL, placeholder: UIImage(name: "placeholder"))
  }

  private func setupUI() {
    backgroundColor = .secondarySystemBackground
    constructHierarchy()
    activateConstraints()
    setupViews()
  }

  private func setupViews() {
    separatorView.backgroundColor = .separator
    separatorView.alpha = 0.2
  }

  private func constructHierarchy() {
    contentView.addSubview(separatorView)
    contentView.addSubview(episodeImageView)
    contentView.addSubview(rightContainerStackView)
  }

  private func activateConstraints() {
    var constraints = [NSLayoutConstraint]()
    constraints.append(contentsOf: activateConstraintsForSeparatorView())
    constraints.append(contentsOf: activateConstraintsForPosterView())
    constraints.append(contentsOf: activateConstraintsForLeftStackView())
    NSLayoutConstraint.activate(constraints)
  }

  private func activateConstraintsForSeparatorView()  -> [NSLayoutConstraint] {
    separatorView.translatesAutoresizingMaskIntoConstraints = false
    return [
      separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
      separatorView.heightAnchor.constraint(equalToConstant: 1.0)
    ]
  }

  private func activateConstraintsForPosterView() -> [NSLayoutConstraint] {
    return [
      episodeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      episodeImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
      episodeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      episodeImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.35),
      episodeImageView.heightAnchor.constraint(equalToConstant: 150)
    ]
  }

  private func activateConstraintsForLeftStackView() -> [NSLayoutConstraint] {
    let centerConstraint = rightContainerStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    centerConstraint.priority = .defaultHigh
    return [
      rightContainerStackView.leadingAnchor.constraint(equalTo: episodeImageView.trailingAnchor, constant: 8),
      rightContainerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      rightContainerStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
      rightContainerStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
      centerConstraint
    ]
  }

  override func prepareForReuse() {
    episodeImageView.image = nil
  }
}
