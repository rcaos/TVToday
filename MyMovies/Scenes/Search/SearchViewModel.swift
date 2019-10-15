//
//  SearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class SearchViewModel{
    
    private let genreService = ApiClient<GenreProvider>()
    
    var genres:[Genre]
    
    //Bindables
    var viewState:Bindable<ViewState> = Bindable(.loading)
    
    init() {
        genres = []
    }
    
    func getGenres(){
        
        genreService.load(service: .getAll, decodeType: GenreListResult.self, completion: { result in
            switch result{
            case .success(let response):
                self.processFetched(for: response.genres)
            case .failure(let error):
                print("error: [\(error)]")
            }
        })
    }
    
    //MARK: - Private
    private func processFetched(for genres: [Genre]){
        self.genres.append(contentsOf: genres)
        self.viewState.value = .populated(genres)
    }
    
}

extension SearchViewModel{
    
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
