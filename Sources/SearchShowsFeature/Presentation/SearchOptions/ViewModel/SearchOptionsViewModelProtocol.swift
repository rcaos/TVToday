//
//  SearchOptionsViewModelProtocol.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 8/7/20.
//

import Combine

protocol SearchOptionsViewModelDelegate: AnyObject {
  func searchOptionsViewModel(_ searchOptionsViewModel: SearchOptionsViewModel,
                              didGenrePicked idGenre: Int,
                              title: String?)

  func searchOptionsViewModel(_ searchOptionsViewModel: SearchOptionsViewModel,
                              didRecentShowPicked idShow: Int)
}

protocol SearchOptionsViewModelProtocol: VisitedShowViewModelDelegate {
  // MARK: - Input
  func viewDidLoad()
  func modelIsPicked(with item: SearchSectionItem)

  // MARK: - Output
  var viewState: CurrentValueSubject<SearchViewState, Never> { get }
  var dataSource: CurrentValueSubject<[SearchOptionsSectionModel], Never> { get }
}
