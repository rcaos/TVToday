//
//  PopularsViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class PopularViewModel: ShowsViewModel{
    
    private let showsService = ApiClient<TVShowsProvider>()
    
    var shows: [TVShow]
    var showCells: [TVShowCellViewModel]
    
    //Bindables
    var viewState:Bindable<ViewState> = Bindable(.loading)
    
    init() {
        shows = []
        showCells = []
    }
    
    //MARK: - Fetch Shows
    func getShows(){
        self.viewState.value = .loading
        
        showsService.load(service: .getPopularTVShows , decodeType: TVShowResult.self, completion: { result in
            switch result{
            case .success(let response):
                self.processFetched(for: response.results)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    //MARK: - Private
    private func processFetched(for shows: [TVShow]){
        //print("Se recibieron : [\(shows.count) Popular shows]. Actualizar TableView")
        self.shows.append(contentsOf: shows)
        
        //Build Models
        self.showCells = self.shows.map({
            return TVShowCellViewModel(show: $0)
        })
        self.viewState.value = .populated( shows )
    }
    
    //MARK: - Build Models
    func buildShowDetailViewModel(for showId: Int) -> TVShowDetailViewModel {
        return TVShowDetailViewModel(showId)
    }
}

extension PopularViewModel{
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
