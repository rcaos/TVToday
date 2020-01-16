//
//  TVShowsRepository.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol TVShowsRepository {
    
    func tvShowsList(with filter: TVShowsListFilter,
                     page: Int,
                     completion: @escaping(Result<TVShowResult,Error>) -> Void) -> Cancellable?
}

// MARK: - TVShowsListFilter

enum TVShowsListFilter {

    case today, popular
    
    case byGenre(genreId: Int)
    
    case search(query: String)
}
