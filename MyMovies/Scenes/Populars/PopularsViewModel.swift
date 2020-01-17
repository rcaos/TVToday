//
//  PopularsViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class PopularViewModel {
    
    private let fetchPopularsShowsUseCase: FetchTVShowsUseCase
    
    var shows: [TVShow]
    var models: [TVShowCellViewModel]
    
    //Bindables
    var viewState:Bindable<ViewState> = Bindable(.loading)
    
    private var showsLoadTask: Cancellable? {
        willSet {
            showsLoadTask?.cancel()
        }
    }
    
    // MARK: - Initializers
    
    init(fetchPopularsShowsUseCase: FetchTVShowsUseCase) {
        self.fetchPopularsShowsUseCase = fetchPopularsShowsUseCase
        shows = []
        models = []
    }
    
    //MARK: - Fetch Shows
    
    func getShows(for page: Int) {
        self.viewState.value = .loading
        
        let request = FetchTVShowsUseCaseRequestValue(filter: .popular, page: page)
        
        showsLoadTask = fetchPopularsShowsUseCase.execute(requestValue: request) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let results):
                strongSelf.processFetched(for: results)
            case .failure(let error):
                // MARK: - TODO , handle error at View
                print("Error to fetch Case use \(error)")
            }
        }
    }
    
    //MARK: - Private
    
    private func processFetched(for response: TVShowResult) {
        var fetchedShows:[TVShow] = []
        if let shows = response.results {
            fetchedShows.append(contentsOf: shows)
        }
        
        self.shows.append(contentsOf: fetchedShows)
        self.models.append(contentsOf: fetchedShows.map({ return TVShowCellViewModel(show: $0) }) )
        
        if response.hasMorePages {
            self.viewState.value = .paging( shows, response.nextPage)
        } else {
            self.viewState.value = .populated( shows )
        }
    }
    
    //MARK: - Build Models - BORRAR
    
    func buildShowDetailViewModel(for showId: Int) -> TVShowDetailViewModel {
        return TVShowDetailViewModel(showId, fetchDetailShowUseCase: nil)
    }
}

extension PopularViewModel {
    
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
