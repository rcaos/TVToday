//
//  ProfileTableViewCell.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/22/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import Shared
import UI

class ProfileTableViewCell: NiblessTableViewCell {
  private let nameLabel = UILabel(frame: .zero)

  private let avatarImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  func setModel(with entity: Account) {
    nameLabel.text = "Hi \(entity.userName)!"

    if let hash = entity.avatar?.hashId {
      let imageURL = "https://www.gravatar.com/avatar/\(hash)"  // MARK: - TODO, move to configuration
      avatarImageView.setImage(with: URL(string: imageURL))
    }
  }

  private func setupUI() {
    backgroundColor = .secondarySystemBackground
    constructHierarchy()
    activateConstraints()
    setupViews()
  }

  private func setupViews() {
    nameLabel.font = .app_title3().bolded
    nameLabel.textAlignment  = .center
  }

  private func constructHierarchy() {
    addSubview(nameLabel)
    addSubview(avatarImageView)
  }

  private func activateConstraints() {
    activateConstraintsForTitleLabel()
    activateConstraintsForImage()
  }

  private func activateConstraintsForTitleLabel() {
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
      nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      nameLabel.bottomAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: -10)
    ])
  }

  private func activateConstraintsForImage() {
    avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      avatarImageView.widthAnchor.constraint(equalToConstant: 100),
      avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
      avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: 1)
    ])
  }
}
