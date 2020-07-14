//
//  TVShowViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import UI

public class TVShowViewCell: UITableViewCell {
  
  @IBOutlet weak private var nameLabel: TVRegularLabel!
  @IBOutlet weak private var averageLabel: TVRegularLabel!
  
  public var viewModel: TVShowCellViewModel? {
    didSet {
      setupUI()
    }
  }
  
  public override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  private func setupUI() {
    guard let viewModel = viewModel else { return }
    
    nameLabel.text = viewModel.name
    averageLabel.text = viewModel.average
  }
  
}
