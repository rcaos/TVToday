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
  
  @IBOutlet weak private var posterImageView: UIImageView!
  @IBOutlet weak private var nameLabel: TVBoldLabel!
  @IBOutlet weak private var startYearLabel: TVRegularLabel!
  @IBOutlet weak private var starImageView: UIImageView!
  @IBOutlet weak private var averageLabel: TVRegularLabel!
  
  public var viewModel: TVShowCellViewModel? {
    didSet {
      setupUI()
    }
  }
  
  public override func awakeFromNib() {
    super.awakeFromNib()
    
    starImageView.image = UIImage(name: "star")
  }
  
  private func setupUI() {
    guard let viewModel = viewModel else { return }
    
    posterImageView.setImage(with: viewModel.posterPathURL)
    nameLabel.text = viewModel.name
    startYearLabel.text = viewModel.firstAirDate
    averageLabel.text = viewModel.average
  }
  
}
