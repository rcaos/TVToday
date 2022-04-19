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
      seasonNumber.backgroundColor = isSelected ? .systemYellow : .clear
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
    backgroundColor = .secondarySystemBackground
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
    seasonNumber.backgroundColor = .clear
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
    seasonNumber.textColor = .label
  }
}
