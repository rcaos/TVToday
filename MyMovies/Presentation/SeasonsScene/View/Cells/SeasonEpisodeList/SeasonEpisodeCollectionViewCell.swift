//
//  SeasonEpisodeCollectionViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/24/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class SeasonEpisodeCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var seasonNumber: UILabel! {
    didSet {
      self.seasonNumber.backgroundColor = ColorsForCell.normal.rawValue
      self.seasonNumber.textColor = .black
      self.seasonNumber.clipsToBounds = true
      self.seasonNumber.layer.masksToBounds = true
      self.seasonNumber.layer.cornerRadius = self.seasonNumber.frame.width / 2
      self.seasonNumber.textAlignment = .center
    }
  }
  
  var viewModel: SeasonEpisodeCollectionViewModel? {
    didSet {
      setupUI()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override var isSelected: Bool {
    didSet {
      if isSelected {
        seasonNumber.backgroundColor = ColorsForCell.selected.rawValue
      } else {
        seasonNumber.backgroundColor = ColorsForCell.normal.rawValue
      }
    }
  }
  
  func setupUI() {
    seasonNumber.text = viewModel?.seasonNumber
  }
}

enum ColorsForCell {
  
  case selected
  case normal
  
  var rawValue: UIColor {
    switch self {
    case .selected:
      return UIColor(red: 255.0/255.0, green: 202.0/255.0, blue: 40.0/255.0, alpha: 0.8)
    case .normal:
      return UIColor.clear
    }
  }
}
