//
//  RepositoryTask.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

struct RepositoryTask: Cancellable {
    
    let networkTask: NetworkCancellable?
    
    func cancel() {
        networkTask?.cancel()
    }
}
