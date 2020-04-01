//
//  EpisodeItemTableViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class EpisodeItemTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var episodeImage: UIImageView!
  @IBOutlet private weak var episodeNumberLabel: UILabel!
  @IBOutlet private weak var episodeNameLabel: UILabel!
  @IBOutlet private weak var releaseLabel: UILabel!
  @IBOutlet private weak var durationLabel: UILabel!
  @IBOutlet private weak var averageLabel: UILabel!
  
  var viewModel: EpisodeItemViewModel? {
    didSet{
      setupUI()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setupUI() {
    durationLabel.text = ""
    
    episodeNumberLabel.text = viewModel?.episodeNumber
    episodeNameLabel.text = viewModel?.episodeName
    releaseLabel.text = viewModel?.releaseDate
    averageLabel.text = viewModel?.average
    episodeImage.setImage(with: viewModel?.posterURL, placeholder: UIImage(named: "placeholder"))
  }
  
  override func prepareForReuse() {
    episodeImage.image = nil
  }
}
