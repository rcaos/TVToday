//
//  SearchViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Shared
import Persistence

// MARK: - TODO, handle searchUIBar reactive too

class SearchViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet var tableView: UITableView!
  var searchController: UISearchController!
  
  private var viewModel: SearchViewModel!
  
  var lastSearch = ""
  
  var loadingView = LoadingView(frame: .zero)
  var messageView = MessageView(frame: .zero)
  
  let disposeBag = DisposeBag()
  
  static func create(with viewModel: SearchViewModel) -> SearchViewController {
    let controller = SearchViewController.instantiateViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: - SetupView
  
  func setupUI() {
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationItem.title = "Search TV Shows"
    
    setupViews()
    setupTable()
    setupSearchBar()
    bind(to: viewModel)
    viewModel.getGenres()
  }
  
  func setupViews() {
    loadingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
    messageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
  }
  
  func setupTable() {
    tableView.registerNib(cellType: VisitedShowTableViewCell.self)
    tableView.registerNib(cellType: GenericViewCell.self)
    tableView.rowHeight = UITableView.automaticDimension
  }
  
  func setupSearchBar() {
    let resultViewModel = viewModel.buildResultsSearchViewModel()
    let resultsController = ResultsSearchViewController(viewModel: resultViewModel)
    
    resultsController.delegate = self
    
    searchController = UISearchController(searchResultsController: resultsController)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.placeholder = "Search TV Show"
    searchController.searchBar.delegate = self
    
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    
    definesPresentationContext = true
  }
  
  func bind(to viewModel: SearchViewModel) {
    viewModel.output.viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.handleTableState(with: state)
      })
      .disposed(by: disposeBag)
    
    let dataSource = RxTableViewSectionedReloadDataSource<SearchSectionModel>(configureCell: { [weak self] (_, _, indexPath, element) -> UITableViewCell in
      guard let strongSelf = self else { fatalError() }
      switch element {
      case .showsVisited(items: let shows):
        return strongSelf.makeCellForShowVisited(at: indexPath, element: shows)
      case .genres(items: let genre):
        return strongSelf.makeCellForGenre(at: indexPath, element: genre)
      }
    })
    
    viewModel.output
      .dataSource
    .debug()
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    tableView.rx
    .setDelegate(self)
    .disposed(by: disposeBag)
    
    Observable
      .zip( tableView.rx.itemSelected, tableView.rx.modelSelected(SearchSectionModel.Item.self) )
      .bind { [weak self] (indexPath, item) in
        guard let strongSelf = self else { return }
        strongSelf.tableView.deselectRow(at: indexPath, animated: true)
        strongSelf.viewModel.modelIsPicked(with: item)
    }
    .disposed(by: disposeBag)
  }
  
  func handleTableState(with state: SimpleViewState<Genre>) {
    switch state {
    case .populated:
      tableView.tableFooterView = nil
      
    case .loading, .paging:
      tableView.tableFooterView = loadingView
      
    case .empty:
      messageView.messageLabel.text = "No genres to Show"
      tableView.tableFooterView = messageView
      
    case .error(let message):
      messageView.messageLabel.text = message
      tableView.tableFooterView = messageView
    }
  }
  
  func clearResults() {
    guard let controller = searchController.searchResultsController as? ResultsSearchViewController else { return }
    controller.viewModel.clearShows()
  }
  
  func search(for query: String) {
    guard let controller = searchController.searchResultsController as? ResultsSearchViewController else { return }
    controller.viewModel.searchShows(for: query, page: 1)
  }
  
}

// MARK: - Build Cells

extension SearchViewController {
  
  private func makeCellForShowVisited(at indexPath: IndexPath, element: [ShowVisited]) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: VisitedShowTableViewCell.self, for: indexPath)
    let cellViewModel = VisitedShowViewModel(shows: element)
    cellViewModel.delegate = viewModel
    cell.setupCell(with: cellViewModel)
    return cell
  }
  
  private func makeCellForGenre(at indexPath: IndexPath, element: Genre) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: GenericViewCell.self, for: indexPath)
    cell.title = element.name
    return cell
  }
}

extension SearchViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return indexPath.section == 0 ? 200 : UITableView.automaticDimension
  }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    searchController.searchResultsController?.view.isHidden = false
  }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let query = searchBar.text {
      
      if query.lowercased() != lastSearch.lowercased() {
        clearResults()
        lastSearch = query
        search(for: query)
      }
    }
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    lastSearch = ""
    clearResults()
  }
}

// MARK: - ResultsSearchViewControllerDelegate

extension SearchViewController: ResultsSearchViewControllerDelegate {
  
  func resultsSearchViewController(_ resultsSearchViewController: ResultsSearchViewController, didSelectedMovie movie: Int) {
    viewModel.showIsPicked(with: movie)
  }
}
