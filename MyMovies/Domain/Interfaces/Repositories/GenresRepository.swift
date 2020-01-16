//
//  GenresRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol GenresRepository {
    
    func genresList(completion: @escaping(Result<GenreListResult,Error>) -> Void) -> Cancellable?
}
