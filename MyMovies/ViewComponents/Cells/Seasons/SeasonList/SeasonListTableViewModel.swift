//
//  SeasonListTableViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class SeasonListTableViewModel {
    
    var episodeNumber: String?
    var episodeName: String?
    var releaseDate: String?
    var duration: String?
    var average: String?
    
    var data: Data?
    
    var episode: Episode!
    
    init(episode: Episode) {
        self.episode = episode
        setupData()
    }
    
    private func setupData(){
        if let number = episode.episodeNumber{
            episodeNumber = String(number) + "."
        }
        
        episodeName = episode.name
        releaseDate = episode.airDate
        average = episode.average
    }
}
