//
//  GenreViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class GenreViewCell: UITableViewCell {
  
  public static let identifier = "GenreViewCell"
  
  var genre: Genre? {
    didSet {
      setupUI()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setupUI() {
    textLabel?.text = genre?.name
  }
  
}
