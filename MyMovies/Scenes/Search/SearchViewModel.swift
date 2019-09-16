//
//  SearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class SearchViewModel{
    
    var genres:[Genre]
    var reloadData:Bindable<Bool>
    
    init() {
        genres = []
        reloadData = Bindable(false)
    }
    
    func getGenres(){
        
        TMDBClient.getGenresTVShows(completion: { result, error in
            if let shows = result{
                self.processFetched(for: shows)
            }
        })
    }
    
    //MARK: - Private
    private func processFetched(for shows: [Genre]){
        print("\nSe recibieron : [\(shows.count) Genres]. Actualizar TableView")
        self.genres.append(contentsOf: shows)
        self.reloadData.value = true
    }
    
}
