//
//  SeasonEpisodeTableViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/24/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class SeasonEpisodeTableViewModel {
    
    var seasons:[Int]
    
    var cellModels:[SeasonEpisodeCollectionViewModel] {
        return seasons.map( {
            SeasonEpisodeCollectionViewModel(seasonNumber: $0)
        } )
    }
    
    var selectedCell: ( (Int) -> Void)?
    
    // MARK: Initalizer
    
    init( seasons: [Int] ) {
        self.seasons = seasons
    }
    
    func getSeasonNumber(for index: Int) -> Int? {
        return seasons[index]
    }
    
    func getNumberOfSeasons() -> Int {
        return seasons.count
    }
    
    func getModelFor(_ indexPath: Int) -> SeasonEpisodeCollectionViewModel {
        return cellModels[indexPath]
    }
}
