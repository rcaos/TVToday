//
//  AiringTodayViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class AiringTodayViewModel{
    
    private var tvShows:[TVShow]
    private var showCells:[TVShowCellViewModel]
    
    //MARK: - Bindings
    var reloadTable: (()->())?
    
    var numberOfCells: Int{
        return tvShows.count
    }
    
    //MARK: - Initializers
    init() {
        tvShows = []
        showCells = []
    }
    
    //MARK: - Fetch Shows
    func getShows(){
        TMDBClient.getAiringTodayShows(completion: { result, error in
            if let shows = result{
                self.processFetched(for: shows)
            }
        })
    }
    
    //MARK: - Get Cell Model
    func getCellViewModel(at indexPath: IndexPath) -> TVShowCellViewModel{
        return showCells[indexPath.row]
    }
    
    //MARK: - Get Show Id
    func getShowID(at indexPath: IndexPath) -> Int{
        return tvShows[indexPath.row].id
    }
    
    //MARK: - Private
    private func processFetched(for shows: [TVShow]){
        print("Se recibieron : [\(shows.count) shows]. Actualizar TableView")
        self.tvShows.append(contentsOf: shows)
        
        for show in shows{
            let modelforCell = TVShowCellViewModel(show: show)
            self.showCells.append(modelforCell)
        }
        print("Ahora existen: [\(showCells.count) Models]")
        self.reloadTable?()
    }

}
