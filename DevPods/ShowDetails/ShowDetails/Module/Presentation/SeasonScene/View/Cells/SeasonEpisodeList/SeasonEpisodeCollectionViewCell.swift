//
//  SeasonEpisodeCollectionViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/24/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UI

class SeasonEpisodeCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var seasonNumber: TVRegularLabel! {
    didSet {
      self.seasonNumber.backgroundColor = Colors.clear.color
      self.seasonNumber.clipsToBounds = true
      self.seasonNumber.layer.masksToBounds = true
      self.seasonNumber.layer.cornerRadius = self.seasonNumber.frame.width / 2
      self.seasonNumber.textAlignment = .center
    }
  }
  
  var viewModel: SeasonEpisodeViewModel? {
    didSet {
      setupUI()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override var isSelected: Bool {
    didSet {
      seasonNumber.backgroundColor = isSelected ? Colors.customYellow.color : Colors.clear.color
    }
  }
  
  func setupUI() {
    seasonNumber.text = viewModel?.seasonNumber
  }
}
