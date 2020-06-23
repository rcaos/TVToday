//
//  GenreViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class GenericViewCell: UITableViewCell {
  
  public static let identifier = "GenericViewCell"
  
  var title: String? {
    didSet {
      setupUI()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setupUI() {
    textLabel?.text = title
  }
  
}
