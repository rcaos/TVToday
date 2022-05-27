//
//  RecentSearchTableViewCell.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/7/20.
//

import UIKit
import Shared
import UI

class RecentSearchTableViewCell: NiblessTableViewCell {

  private let titleLabel = UILabel()

  private let accessoryImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "arrow.up.left")
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  func setModel(with text: String) {
    titleLabel.text = text
  }

  private func setupUI() {
    backgroundColor = .secondarySystemBackground
    constructHierarchy()
    activateConstraints()
  }

  private func constructHierarchy() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(accessoryImageView)
  }

  private func activateConstraints() {
    activateConstraintsForLabel()
    activateConstraintsForImage()
  }

  private func activateConstraintsForLabel() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: accessoryImageView.leadingAnchor, constant: -8),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }

  private func activateConstraintsForImage() {
    accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      accessoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      accessoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      accessoryImageView.widthAnchor.constraint(equalToConstant: 24),
      accessoryImageView.heightAnchor.constraint(equalToConstant: 24)
    ])
  }

}
