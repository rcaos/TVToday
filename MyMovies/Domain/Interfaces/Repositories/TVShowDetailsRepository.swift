//
//  TVShowDetailsRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol TVShowDetailsRepository {

    @discardableResult
    func tvShowDetails(with identifier: Int,
                       completion: @escaping(Result<TVShowDetailResult,Error>) -> Void) -> Cancellable?
}
