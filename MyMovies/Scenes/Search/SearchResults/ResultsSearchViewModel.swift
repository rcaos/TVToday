//
//  ResultsSearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class ResultsSearchViewModel: ShowsViewModel {
    
    private let fetchSearchShowsUseCase: FetchTVShowsUseCase?
    
//    private let showsService = ApiClient<TVShowsProvider>()
    
    var shows: [TVShow]
    var models: [TVShowCellViewModel]
    
    var currentSearch = ""
    
    //Bindable
    var viewState:Bindable<ViewState> = Bindable(.loading)
    
    private var showsLoadTask: Cancellable? {
        willSet {
            showsLoadTask?.cancel()
        }
    }
    
    init(fetchSearchShowsUseCase: FetchTVShowsUseCase?) {
        self.fetchSearchShowsUseCase = fetchSearchShowsUseCase
        shows = []
        models = []
    }
    
    //MARK: - Fetch Shows
    func searchShow(for page: Int) {
        guard !currentSearch.isEmpty else { return }
        
        searchShows(for: currentSearch, page: page)
    }
    
    func searchShows(for name: String, page: Int) {
        self.viewState.value = .loading
        currentSearch = name
        
        let request = FetchTVShowsUseCaseRequestValue(filter: .search(query: name), page: page)
        
        showsLoadTask = fetchSearchShowsUseCase?.execute(requestValue: request) {
            [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                strongSelf.processFetched(for: response)
            case .failure(let error):
                // MARK: - TODO // Handle error at View
                print("Error to fetch Case use \(error)")
            }
        }
        
//        showsService.load(service: .searchTVShow(name, page) , decodeType: TVShowResult.self, completion: { result in
//            switch result{
//            case .success(let response):
//                self.processFetched(for: response)
//            case .failure(let error):
//                print("error: [\(error)")
//            }
//        })
    }
    
    func clearShows() {
        shows.removeAll()
        models.removeAll()
        viewState.value = .populated(shows)
    }
    
    //MARK: - Private
    private func processFetched(for response: TVShowResult) {
        print("Page: \(response.page), Total Pages: \(response.totalPages), Has More Pages: \(response.hasMorePages), Next Page: \(response.nextPage)\n")
        
        var fetchedShows:[TVShow] = []
        if let shows = response.results {
            fetchedShows = shows
        }
        
        if fetchedShows.isEmpty {
            self.viewState.value = .empty
            return
        }
        
        self.shows.append(contentsOf: fetchedShows)
        self.models.append(contentsOf: fetchedShows.map({ return TVShowCellViewModel(show: $0) }) )
        
        if response.hasMorePages {
            self.viewState.value = .paging(shows, response.nextPage)
        } else {
            self.viewState.value = .populated(shows)
        }
    }
}

extension ResultsSearchViewModel {
    
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
