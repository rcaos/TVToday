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
    func getShows(for page: Int){
        self.viewState.value =  .loading
        
        showsService.load(service: .getAiringTodayShows(page), decodeType: TVShowResult.self, completion: { result in
            switch result{
            case .success(let response):
                print("Page: \(response.page), Total Pages: \(response.totalPages), Has More Pages: \(response.hasMorePages), Next Page: \(response.nextPage)\n")
               self.processFetched(for: response)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getModelFor(_ index:Int) -> AiringTodayCollectionViewModel{
        return models[index]
    }
    
    //MARK: - Private
    private func processFetched(for response: TVShowResult){
        var fetchedShows : [TVShow] = []
        if let shows = response.results {
            fetchedShows = shows
        }
        
        //TODO: - Empty View -
        
        self.shows.append(contentsOf: fetchedShows)
        self.models.append(contentsOf:
            fetchedShows.map({ return AiringTodayCollectionViewModel(show: $0) }) )
        
        if response.hasMorePages {
            self.viewState.value = .paging( self.shows , response.nextPage)
        } else {
            self.viewState.value = .populated( self.shows )
        }
    }
    
    //MARK: - Build Models
    func buildShowDetailViewModel(for showId: Int) -> TVShowDetailViewModel {
        return TVShowDetailViewModel(showId)
    }
}

extension AiringTodayViewModel{
    
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
