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
  private let nameLabel = TVRegularLabel(frame: .zero)

  private let avatarImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  func setModel(with entity: AccountResult) {
    if let userName = entity.userName {
      nameLabel.text = "Hi \(userName)!"
    }

    if let hash = entity.avatar?.gravatar?.hash {
      let imageURL = "https://www.gravatar.com/avatar/\(hash)"
      avatarImageView.setImage(with: URL(string: imageURL))
    }
  }

  private func setupUI() {
    constructHierarchy()
    activateConstraints()
    setupViews()
  }

  private func setupViews() {
    nameLabel.tvSize = .custom(25)
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
