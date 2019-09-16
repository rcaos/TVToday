//
//  ResultsSearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class ResultsSearchViewModel: ShowsViewModel{
    var shows: [TVShow]
    var showCells: [TVShowCellViewModel]
    var reloadData: Bindable<Bool>
    
    init() {
        shows = []
        showCells = []
        reloadData = Bindable(false)
    }
    
    //MARK: - Fetch Shows
    func searchShows(for name: String){
        TMDBClient.search(for: name, completion: { result, error in
            if let shows = result{
                self.processFetched(for: shows)
            }
        })
    }
    
    func clearShows(){
        shows.removeAll()
        showCells.removeAll()
        reloadData.value = true
    }
    
    //MARK: - Private
    private func processFetched(for shows: [TVShow]){
        print("\nSe recibieron : [\(shows.count) resultados]")
        self.shows.append(contentsOf: shows)
        
        for show in shows{
            let modelforCell = TVShowCellViewModel(show: show)
            self.showCells.append(modelforCell)
        }
        print("Ahora existen: [\(showCells.count) Models]\n")
        self.reloadData.value = true
    }
}
