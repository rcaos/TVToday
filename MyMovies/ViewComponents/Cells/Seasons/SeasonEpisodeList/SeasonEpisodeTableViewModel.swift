//
//  SeasonEpisodeTableViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/24/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class SeasonEpisodeTableViewModel{
    
    var seasons:[Int]
    
    var cellModels:[SeasonEpisodeCollectionViewModel] {
        return seasons.map( {
            SeasonEpisodeCollectionViewModel(seasonNumber: $0)
        } )
    }
    
    var seasonSelected:Int?
    
    //Reactive
    var selectedCell: ( (Int) -> Void)?
    
    //MARK: Life Cycle
    init( seasons: [Int] , season : Int? = nil) {
        self.seasons = seasons
        self.seasonSelected = season
    }
    
    func getSeasonNumber(for index: Int) -> Int?{
        return seasons[index]
    }
    
    func getNumberOfSeasons() -> Int{
        return seasons.count
    }
    
    func getModelFor(_ indexPath: Int) -> SeasonEpisodeCollectionViewModel {
        
        var model = cellModels[indexPath]
        
//        if let season = seasonSelected{
//            if model.season == season{
//                model.isSelected = true
//            }
//        }
        
        return model
        //return cellModels[indexPath]
    }
}
