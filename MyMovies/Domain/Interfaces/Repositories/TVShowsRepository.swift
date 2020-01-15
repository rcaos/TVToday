//
//  TVShowsRepository.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol TVShowsRepository {
    
    func tvShowsList(page: Int,
                     completion: @escaping(Result<TVShowResult,Error>) -> Void) -> Cancellable?
}
