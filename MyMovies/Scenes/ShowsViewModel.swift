//
//  ShowsViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

protocol ShowsViewModel{
    
    //var movieClient: --For Networking
    var shows:[TVShow] { get }
    //var showCells:[TVShowCellViewModel] { get }
    
}
