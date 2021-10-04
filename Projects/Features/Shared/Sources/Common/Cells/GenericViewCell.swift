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

  public override func awakeFromNib() {
    super.awakeFromNib()
  }

  public func setupUI(with title: String?) {
    regularTextLabel?.text = title
  }

  deinit {
    print("deinit GenericViewCell")
  }
}
