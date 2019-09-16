//
//  PopularsViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class PopularViewModel: ShowsViewModel{
    var shows: [TVShow]
    var showCells: [TVShowCellViewModel]
    var reloadData: Bindable<Bool>
    
    init() {
        shows = []
        showCells = []
        reloadData = Bindable(false)
    }
    
    //MARK: - Fetch Shows
    func getShows(){
        TMDBClient.getPopularShows(completion: { result, error in
            if let shows = result{
                self.processFetched(for: shows)
            }
        })
    }
    
    //MARK: - Private
    private func processFetched(for shows: [TVShow]){
        print("Se recibieron : [\(shows.count) Popular shows]. Actualizar TableView")
        self.shows.append(contentsOf: shows)
        
        for show in shows{
            let modelforCell = TVShowCellViewModel(show: show)
            self.showCells.append(modelforCell)
        }
        print("Ahora existen: [\(showCells.count) Models]")
        self.reloadData.value = true
    }
    
}
