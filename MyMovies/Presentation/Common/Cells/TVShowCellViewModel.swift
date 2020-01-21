//
//  TVShowCellViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class TVShowCellViewModel{
    var name: String?
    var average: String?
    
    init(show: TVShow) {
        name = show.name
        
        if let voteAverage = show.voteAverage{
            average = String(voteAverage)
        }else{
            average = ""
        }
    }
}
