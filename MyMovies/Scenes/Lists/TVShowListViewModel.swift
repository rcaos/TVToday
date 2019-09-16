//
//  TVShowListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class TVShowListViewModel: ShowsViewModel{
    var shows: [TVShow]
    var showCells: [TVShowCellViewModel]
    var reloadData: Bindable<Bool>
    
    init() {
        shows = []
        showCells = []
        reloadData = Bindable(false)
    }
    
    func getGenres(by id:  Int){
        print("Consultando por Genre: [\(id)]..")
        TMDBClient.listTVShows(by: id, completion: { result, error in
            if let shows = result{
                self.processFetched(for: shows)
            }
        })
        
    }
    
    //MARK: - Private
    private func processFetched(for shows: [TVShow]){
        print("\nSe recibieron : [\(shows.count) Shows]. Actualizar TableView")
        self.shows.append(contentsOf: shows)
        
        for show in shows{
            let modelforCell = TVShowCellViewModel(show: show)
            self.showCells.append(modelforCell)
        }
        print("Ahora existen: [\(showCells.count) Models]\n")
        self.reloadData.value = true
    }
    
}
