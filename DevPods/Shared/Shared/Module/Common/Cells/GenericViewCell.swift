//
//  GenreViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import UI

public class GenericViewCell: UITableViewCell {
  
  @IBOutlet weak public var regularTextLabel: TVRegularLabel!
  
  public var title: String? {
    didSet {
      setupUI()
    }
  }
  
  public override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setupUI() {
    regularTextLabel?.text = title
  }
  
  deinit {
    print("deinit GenericViewCell")
  }
}
