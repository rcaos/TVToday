//
//  SeasonEpisodeCollectionViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/24/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class SeasonEpisodeCollectionViewModel {
    
    var seasonNumber: String?

    init( seasonNumber: Int) {
        self.seasonNumber = String(seasonNumber)
    }
}
