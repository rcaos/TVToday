//
//  HeaderView.swift
//  MyTvShows
//
//  Created by Jeans on 9/25/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import Shared
import UI

class SeasonHeaderView: UIView, NibLoadable {
  
  @IBOutlet weak var showNameLabel: UILabel!
  @IBOutlet weak var seasonsLabel: UILabel!
  
  var viewModel: SeasonHeaderViewModel? {
    didSet {
      setupUI()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUIElements()
  }
  
  private func setupUIElements() {
    showNameLabel.font = Font.sanFrancisco.of(type: .bold, with: .custom(22))
    showNameLabel.textColor = Colors.electricBlue.color
    
    seasonsLabel.textColor = Colors.davyGrey.color
  }
  
  private func setupUI() {
    showNameLabel.text = viewModel?.showName
  }
}
