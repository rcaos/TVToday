//
//  ProfileTableViewCell.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/22/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import Shared

class ProfileTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  
  public static let identifier = "ProfileTableViewCell"
  
  override func awakeFromNib() {
    super.awakeFromNib()
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
