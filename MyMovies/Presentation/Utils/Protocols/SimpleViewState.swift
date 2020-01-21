//
//  SimpleViewState.swift
//  TVToday
//
//  Created by Jeans on 1/13/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

enum SimpleViewState<Entity> {
    
    case loading
    case paging([Entity], next: Int)
    case populated([Entity])
    case empty
    case error(String)
    
    var currentEntities: [Entity] {
        switch self {
        case .populated(let entities):
            return entities
        case .paging(let entities, next: _):
            return entities
        case .loading, .empty, .error:
            return []
        }
    }
    
    var currentPage: Int {
        switch self {
        case .loading, .populated, .empty, .error:
            return 1
        case .paging(_, next: let page):
            return page
        }
    }
    
    var isInitialPage: Bool {
        return currentPage == 1
    }
}
