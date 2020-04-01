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

// MARK: - TODO, handle searchUiBar reactive too

class SearchViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet var tableView: UITableView!
  var searchController:UISearchController!
  
  private var viewModel:SearchViewModel!
  private var searchViewControllersFactory: SearchViewControllersFactory!
  
  var lastSearch = ""
  
  var loadingView = LoadingView(frame: .zero)
  var messageView = MessageView(frame: .zero)
  
  let disposeBag = DisposeBag()
  
  static func create(with viewModel: SearchViewModel,
                     searchViewControllersFactory: SearchViewControllersFactory) -> SearchViewController {
    let controller = SearchViewController.instantiateViewController()
    controller.viewModel = viewModel
    controller.searchViewControllersFactory = searchViewControllersFactory
    return controller
  }
  
  //MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  //MARK: - SetupView
  
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
    let nibName = UINib(nibName: "GenreViewCell", bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: "GenreViewCell")
  }
  
  func setupSearchBar() {
    let resultViewModel = searchViewControllersFactory.makeSearchResultsViewModel()
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
    
    viewModel.output.viewState
      .map { $0.currentEntities }
      .bind(to: tableView.rx.items(cellIdentifier: "GenreViewCell", cellType: GenreViewCell.self)) { (index, element, cell) in
        cell.genre = element
    }
    .disposed(by: disposeBag)
    
    Observable
      .zip( tableView.rx.itemSelected, tableView.rx.modelSelected(Genre.self) )
      .bind { [weak self] (indexPath, item) in
        guard let strongSelf = self else { return }
        strongSelf.tableView.deselectRow(at: indexPath, animated: true)
        strongSelf.viewModel.showShowsList(genreId: item.id)
    }
    .disposed(by: disposeBag)
    
    viewModel.output
      .route
      .subscribe(onNext: { [weak self] route in
        guard let strongSelf = self else { return }
        strongSelf.handle(route)
      })
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

//MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    searchController.searchResultsController?.view.isHidden = false
  }
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let query = searchBar.text {
      
      if query.lowercased() != lastSearch.lowercased(){
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

//MARK: - ResultsSearchViewControllerDelegate

extension SearchViewController: ResultsSearchViewControllerDelegate {
  
  func resultsSearchViewController(_ resultsSearchViewController: ResultsSearchViewController, didSelectedMovie movie: Int) {
    viewModel.showTVShowDetails(with: movie)
  }
}

// MARK: - TODO: refactor Navigation

extension SearchViewController {
  
  func handle(_ route: SearchViewModelRoute) {
    switch route {
      
    case .initial: break
      
    case .showMovieDetail(let identifier):
      let detailController = searchViewControllersFactory.makeTVShowDetailsViewController(with: identifier)
      navigationController?.pushViewController(detailController, animated: true)
      
    case .showShowList(let genreId):
      let listController = searchViewControllersFactory.makeShowListViewControll(with: genreId)
      navigationController?.pushViewController(listController, animated: true)
    }
  }
}

// MARK: - SearchViewControllersFactory

protocol SearchViewControllersFactory {
  
  func makeSearchResultsViewModel() -> ResultsSearchViewModel
  
  func makeTVShowDetailsViewController(with identifier: Int) -> UIViewController
  
  func makeShowListViewControll(with genre: Int) -> UIViewController
}
