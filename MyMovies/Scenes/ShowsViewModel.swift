//
//  ShowsViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum ShowsListFilter {
    
    case today, popular
    case byGenre(genreId: Int)
    
    var title: String {
        switch self {
        case .today:
            return "Today on TV"
        case .popular:
            return "Popular TV Shows"
        case .byGenre(_):
            return ""
        }
    }
}

protocol ShowsViewModel{
    
//    associatedtype TVShowCellViewModel
//
//    var searchShowsUseCase: String { get set }
//
//    var posterImageRepository: String { get set}
//
//    //var filter: MovieListFilter { get set}
//
//    var viewState: Bindable<SimpleViewState<TVShow>> { get set }
//
//    var tvShowsCells: [TVShowCellViewModel] { get set }
//    var tvShows: [TVShow] { get }
}

//extension ShowsViewModel {
//    
//    var tvShows: [TVShow] {
//        return viewState.value.currentEntities
//    }
//    
//    func buildDetailViewModel(at index: Int) -> TVShowDetailViewModel? {
//        // Tmb Agregar dependencias, Networking, Persistence
//        return TVShowDetailViewModel( tvShows[index].id  )
//    }
//    
//    private func fetchShows(currentPage: Int) {
//        //Caso de uso .getShows
//    }
//    private func processShowsResult(_ showResult: TVShowResult) {
//        let fetchedShows = showResult.results ?? []
//        
//        let allShows = viewState.value.currentEntities + fetchedShows
//        
//        if allShows.isEmpty {
//            viewState.value = .empty
//            return
//        }
//        
//        if showResult.hasMorePages {
//            viewState.value = .paging(allShows, next: showResult.nextPage)
//        } else {
//            viewState.value = .populated( allShows )
//        }
//    }
//}
