//
//  SearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum SearchViewModelRoute {
    case initial
    case showMovieDetail(identifier: Int)
    case showShowList(genreId: Int)
}

final class SearchViewModel {
    
    private let fetchGenresUseCase: FetchGenresUseCase
    
    var genres:[Genre]
    
    var viewState:Observable<ViewState> = Observable(.loading)
    
    // Routing
    var route: Observable<SearchViewModelRoute> = Observable(.initial)
    
    private var showsLoadTask: Cancellable? {
        willSet {
            showsLoadTask?.cancel()
        }
    }
    
    init(fetchGenresUseCase: FetchGenresUseCase) {
        self.fetchGenresUseCase = fetchGenresUseCase
        genres = []
    }
    
    func getGenres() {
        
        showsLoadTask =  fetchGenresUseCase.execute(requestValue: FetchGenresUseCaseRequestValue()) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                strongSelf.processFetched(for: response)
            case .failure(let error):
                // MARK: - TODO // Handle error at View
                print("Error to fetch Case use \(error)")
            }
        }
    }
    
    //MARK: - Private
    
    private func processFetched(for response: GenreListResult) {
        let fetchedGenres = response.genres ?? []
        
        if fetchedGenres.isEmpty {
            viewState.value = .empty
            return
        }
        
        self.genres.append(contentsOf: fetchedGenres)
        self.viewState.value = .populated(genres)
    }
    
    func showTVShowDetails(with identifier: Int) {
        route.value = .showMovieDetail(identifier: identifier)
    }
    
    func showShowsList(indexPath: Int) {
        guard let genreId = genres[indexPath].id else { return }
        route.value = .showShowList(genreId: genreId)
    }
}

extension SearchViewModel {
    
    enum ViewState {
        case loading
        case populated([Genre])
        case empty
        case error(Error)
        
        var currentEpisodes : [Genre] {
            switch self{
            case .populated(let genres):
                return genres
            default:
                return []
            }
        }
    }
}
