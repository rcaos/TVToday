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
    return imageView
  }()

  private let episodeNameLabel = TVRegularLabel(frame: .zero)

  private let releaseLabel = TVRegularLabel(frame: .zero)

  private lazy var rightContainerStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [episodeNameLabel, releaseLabel, averageStackView])
    stack.axis = .vertical
    stack.alignment = .leading
    stack.distribution = .fill
    stack.spacing = 8.0

    stack.setContentCompressionResistancePriority(.required, for: .horizontal)

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
    activateConstraintsForSeparatorView()
    activateConstraintsForPosterView()
    activateConstraintsForLeftStackView()
  }

  private func activateConstraintsForSeparatorView() {
    separatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
      separatorView.heightAnchor.constraint(equalToConstant: 1.0)
    ])
  }

  private func activateConstraintsForPosterView() {
    episodeImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      episodeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      episodeImageView.trailingAnchor.constraint(equalTo: rightContainerStackView.leadingAnchor, constant: -8),
      episodeImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
      episodeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      episodeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
  }

  private func activateConstraintsForLeftStackView() {
    rightContainerStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      rightContainerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      rightContainerStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

  override func prepareForReuse() {
    episodeImageView.image = nil
  }
}
