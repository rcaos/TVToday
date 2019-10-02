//
//  AiringTodayViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class AiringTodayViewModel: ShowsViewModel{
    
    var shows:[TVShow]
    var showCells:[AiringTodayCollectionViewModel] {
        return shows.map({
            return AiringTodayCollectionViewModel(show: $0)
        })
    }
    
    //Bindables
    var viewState:Bindable<ViewState> = Bindable(.loading)
    
    //MARK: - Initializers
    init() {
        shows = []
    }
    
    //MARK: - Fetch Shows
    func getShows(){
        self.viewState.value =  .loading
        
        TMDBClient.getAiringTodayShows(completion: { result, error in
            if let shows = result{
                self.processFetched(for: shows)
            }
        })
    }
    
    func getModelFor(_ index:Int) -> AiringTodayCollectionViewModel{
        return showCells[index]
    }
    
    //MARK: - Private
    private func processFetched(for shows: [TVShow]){
        print("Se recibieron : [\(shows.count) shows]. Actualizar TableView")
        self.shows.append(contentsOf: shows)
        self.viewState.value = .populated(shows)
    }

}

extension AiringTodayViewModel{
    
    enum ViewState {
        
        case loading
        case populated([TVShow])
        case empty
        case error(Error)
        
        var currentEpisodes : [TVShow] {
            switch self{
            case .populated(let episodes):
                return episodes
            default:
                return []
            }
        }
    }
}
