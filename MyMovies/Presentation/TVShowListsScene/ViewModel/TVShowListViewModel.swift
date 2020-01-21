//
//  TVShowListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class TVShowListViewModel: ShowsViewModel {
    
    private let fetchShowListUseCase: FetchTVShowsUseCase
    
    var shows: [TVShow]
    var models: [TVShowCellViewModel]
    
    var genreId: Int!
    
    var viewState:Bindable<ViewState> = Bindable(.loading)
    
    private var showsLoadTask: Cancellable? {
        willSet {
            showsLoadTask?.cancel()
        }
    }
    
    // MARK: - Initializers
    
    init(genreId: Int, fetchShowListUseCase: FetchTVShowsUseCase) {
        self.fetchShowListUseCase = fetchShowListUseCase
        self.genreId = genreId
        shows = []
        models = []
    }
    
    func getMoviesForGenre(from page: Int) {
        
        viewState.value = .loading
        
        let request = FetchTVShowsUseCaseRequestValue(filter: .byGenre(genreId: genreId), page: page)
        
        showsLoadTask = fetchShowListUseCase.execute(requestValue: request) { [weak self ] result in
            guard let strongSelf = self else { return }
            switch result{
            case .success(let response):
                strongSelf.processFetched(for: response)
            case .failure(let error):
                // MARK: - TODO // handle errror view
                print(error)
                strongSelf.viewState.value = .error(error)
            }
        }
    }
    
    //MARK: - Private
    
    private func processFetched(for response: TVShowResult ) {
        let fetchedShows = response.results ?? []
        
        self.shows.append(contentsOf: fetchedShows)
        self.models.append(contentsOf: fetchedShows.map({ return TVShowCellViewModel(show: $0) }) )
        
        if response.hasMorePages {
            self.viewState.value = .paging(shows, response.nextPage)
        } else{
            self.viewState.value = .populated(shows)
        }
    }
}

extension TVShowListViewModel {
    
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
