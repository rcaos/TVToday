//
//  AiringTodayViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class AiringTodayViewModel: ShowsViewModel{
    private let showsService = ApiClient<TVShowsProvider>()
    
    var shows:[TVShow]
    var models:[AiringTodayCollectionViewModel]
    
    //Bindables
    var viewState:Bindable<ViewState> = Bindable(.loading)
    
    //MARK: - Initializers
    init() {
        shows = []
        models = []
    }
    
    //MARK: - Fetch Shows
    func getShows(){
        self.viewState.value =  .loading
        
        showsService.load(service: .getAiringTodayShows, decodeType: TVShowResult.self, completion: { result in
            switch result{
            case .success(let response):
               self.processFetched(for: response.results)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getModelFor(_ index:Int) -> AiringTodayCollectionViewModel{
        return models[index]
    }
    
    //MARK: - Private
    private func processFetched(for shows: [TVShow]){
        //print("Se recibieron : [\(shows.count) shows]. Actualizar TableView")
        self.shows.append(contentsOf: shows)
        self.buildModels()
        
        self.viewState.value = .populated(shows)
    }
    
    private func buildModels(){
        for show in shows{
            models.append( AiringTodayCollectionViewModel(show: show) )
        }
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
