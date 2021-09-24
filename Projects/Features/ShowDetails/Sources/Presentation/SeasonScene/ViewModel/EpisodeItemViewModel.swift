//
//  SeasonListTableViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class EpisodeItemViewModel {
  
  var episodeNumber: String?
  var episodeName: String?
  var releaseDate: String?
  var average: String?
  var posterURL: URL?
  
  private let episode: Episode
  
  init(episode: Episode) {
    self.episode = episode
    setupData(with: episode)
  }
  
  private func setupData(with episode: Episode) {
    episodeNumber = String(episode.episodeNumber) + "."
    episodeName = episode.name
    releaseDate = episode.airDate
    average = episode.average
    posterURL = episode.posterPathURL
  }
}
