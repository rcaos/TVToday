//
//  SeasonEpisodeCollectionViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/24/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import Shared
import UI

class SeasonEpisodeCollectionViewCell: NiblessCollectionViewCell {

  private let seasonNumber = TVRegularLabel()

  override var isSelected: Bool {
    didSet {
      seasonNumber.backgroundColor = isSelected ? Colors.customYellow.color : Colors.clear.color
    }
  }

  var viewModel: SeasonEpisodeViewModel?

  // MARK: - Life Cycle
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    layoutCircularLabel()
  }

  private func setupUI() {
    constructHierarchy()
    activateConstraints()
    configureViews()
  }

  private func constructHierarchy() {
    addSubview(seasonNumber)
  }

  private func activateConstraints() {
    seasonNumber.translatesAutoresizingMaskIntoConstraints = false
    seasonNumber.pin(to: self)
  }

  private func configureViews() {
    seasonNumber.backgroundColor = Colors.clear.color
    seasonNumber.textAlignment = .center
  }

  private func layoutCircularLabel() {
    seasonNumber.clipsToBounds = true
    seasonNumber.layer.masksToBounds = true
    seasonNumber.layer.cornerRadius = seasonNumber.frame.width / 2
  }

  func setViewModel(viewModel: SeasonEpisodeViewModel?) {
    self.viewModel = viewModel
    seasonNumber.text = viewModel?.seasonNumber
  }
}
