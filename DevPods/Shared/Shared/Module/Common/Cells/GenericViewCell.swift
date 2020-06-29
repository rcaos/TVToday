//
//  GenreViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

public class GenericViewCell: UITableViewCell {
  
  public var title: String? {
    didSet {
      setupUI()
    }
  }
  
  public override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setupUI() {
    textLabel?.text = title
  }
  
}
