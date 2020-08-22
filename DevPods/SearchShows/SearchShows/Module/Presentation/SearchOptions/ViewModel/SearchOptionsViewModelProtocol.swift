//
//  SearchOptionsViewModelProtocol.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 8/7/20.
//

import RxSwift

protocol SearchOptionsViewModelDelegate: class {
  
  func searchOptionsViewModel(_ searchOptionsViewModel: SearchOptionsViewModel,
                              didGenrePicked idGenre: Int,
                              title: String?)
  
  func searchOptionsViewModel(_ searchOptionsViewModel: SearchOptionsViewModel,
                              didRecentShowPicked idShow: Int)
}

// MARK: - ViewState

enum SearchViewState: Equatable {
  case loading
  case populated
  case empty
  case error(String)
}

protocol SearchOptionsViewModelProtocol: VisitedShowViewModelDelegate {
  
  // MARK: - Input
  
  func viewDidLoad()
  
  func modelIsPicked(with item: SearchOptionsSectionModel.Item)
  
  // MARK: - Output
  
  var viewState: Observable<SearchViewState> { get }
  
  var dataSource: Observable<[SearchOptionsSectionModel]> { get }
}
