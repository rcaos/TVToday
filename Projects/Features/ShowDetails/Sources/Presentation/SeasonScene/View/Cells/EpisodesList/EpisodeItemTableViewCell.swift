//
//  EpisodeItemTableViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import Shared
import UI

class EpisodeItemTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var episodeImage: UIImageView!
  @IBOutlet private weak var episodeNumberLabel: TVRegularLabel!
  @IBOutlet private weak var episodeNameLabel: TVRegularLabel!
  @IBOutlet private weak var releaseLabel: TVRegularLabel!
  @IBOutlet private weak var durationLabel: TVRegularLabel!
  @IBOutlet private weak var starImageView: UIImageView!
  @IBOutlet private weak var averageLabel: TVRegularLabel!
  
  var viewModel: EpisodeItemViewModel? {
    didSet {
      setupUI()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupElements()
  }
  
  private func setupElements() {
    starImageView.image = UIImage(name: "star")
  }
  
  private func setupUI() {
    durationLabel.text = ""
    
    episodeNumberLabel.text = viewModel?.episodeNumber
    episodeNameLabel.text = viewModel?.episodeName
    releaseLabel.text = viewModel?.releaseDate
    averageLabel.text = viewModel?.average
    episodeImage.setImage(with: viewModel?.posterURL, placeholder: UIImage(name: "placeholder"))
  }
  
  override func prepareForReuse() {
    episodeImage.image = nil
  }
}
