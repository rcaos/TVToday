//
//  TVShowListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class TVShowListViewModel: ShowsViewModel{
    private let showsService = ApiClient<TVShowsProvider>()
    
    var shows: [TVShow]
    var models: [TVShowCellViewModel]
    
    var genreId: Int!
    
    //Bindable
    var viewState:Bindable<ViewState> = Bindable(.loading)
    
    init(genreId: Int) {
        self.genreId = genreId
        shows = []
        models = []
    }
    
    func getMoviesForGenre(from page: Int){
        showsService.load(service: .listTVShowsBy(genreId, page) , decodeType: TVShowResult.self, completion: { result in
            switch result{
            case .success(let response):
                self.processFetched(for: response)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    //MARK: - Private
    private func processFetched(for response: TVShowResult ){
        var fetchedShows:[TVShow] = []
        if let shows = response.results {
            fetchedShows = shows
        }
        
        self.shows.append(contentsOf: fetchedShows)
        self.models.append(contentsOf: fetchedShows.map({ return TVShowCellViewModel(show: $0) }) )
        
        if response.hasMorePages {
            self.viewState.value = .paging(shows, response.nextPage)
        } else{
            self.viewState.value = .populated(shows)
        }
    }
    
    //MARK: - Build Models - BORRAR
    func buildShowDetailViewModel(for showId: Int) -> TVShowDetailViewModel {
        return TVShowDetailViewModel(showId, fetchDetailShowUseCase: nil)
    }
}

extension TVShowListViewModel{
    
    enum ViewState {
        
        case loading
        case populated([TVShow])
        case paging([TVShow], Int)
        case empty
        case error(Error)
        
        var currentEpisodes : [TVShow] {
            switch self{
            case .populated(let episodes):
                return episodes
            case .paging(let episodes, _):
                return episodes
            default:
                return []
            }
        }
    }
}
