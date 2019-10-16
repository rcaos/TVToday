//
//  ResultsSearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class ResultsSearchViewModel: ShowsViewModel{
    private let showsService = ApiClient<TVShowsProvider>()
    
    var shows: [TVShow]
    var models: [TVShowCellViewModel]
    
    //Bindable
    var viewState:Bindable<ViewState> = Bindable(.loading)
    
    init() {
        shows = []
        models = []
    }
    
    //MARK: - Fetch Shows
    func searchShows(for name: String){
        self.viewState.value = .loading
        
        showsService.load(service: .searchTVShow(name) , decodeType: TVShowResult.self, completion: { result in
            switch result{
            case .success(let response):
                self.processFetched(for: response.results )
            case .failure(let error):
                print("error: [\(error)")
            }
        })
    }
    
    func clearShows(){
        shows.removeAll()
        models.removeAll()
        viewState.value = .populated(shows)
    }
    
    //MARK: - Private
    private func processFetched(for shows: [TVShow]){
        print("\nSe recibieron : [\(shows.count) resultados]")
        
        if shows.isEmpty {
            self.viewState.value = .empty
            return
        }
        
        self.shows.append(contentsOf: shows)
        
        self.models = shows.map({
            return TVShowCellViewModel(show: $0)
        })
        
        self.viewState.value = .populated( shows )
    }
}

extension ResultsSearchViewModel{
    
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
