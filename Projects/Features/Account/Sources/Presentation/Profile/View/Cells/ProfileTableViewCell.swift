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

class ProfileTableViewCell: UITableViewCell {

  @IBOutlet weak var nameLabel: TVRegularLabel!
  @IBOutlet weak var avatarImageView: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    nameLabel.tvSize = .custom(25)
  }

  func configCell(with entity: AccountResult) {
    if let userName = entity.userName {
      nameLabel.text = "Hi \(userName)!"
    }

    if let hash = entity.avatar?.gravatar?.hash {
      let imageURL = "https://www.gravatar.com/avatar/\(hash)"
      avatarImageView.setImage(with: URL(string: imageURL))
    }
  }
}
