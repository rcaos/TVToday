//
//  SearchViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet var tableView: UITableView!
    var searchController:UISearchController!
    
    private var viewModel:SearchViewModel!
    private var searchViewControllersFactory: SearchViewControllersFactory!
    
    var lastSearch = ""
    
    var loadingView: UIView!
    
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
        
        setupTable()
        setupSearchBar()
        setupViewModel()
    }
    
    //MARK: - SetupTable
    
    func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "GenreViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "GenreViewCell")
    }
    
    //MARK: - SetupSearchBar
    
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
    
    //MARK: - SetupViewModel
    
    func setupViewModel() {
        //Binding
        viewModel.viewState.bindAndFire({[unowned self] state in
            DispatchQueue.main.async {
                self.configView(with: state)
            }
        })
        
        viewModel.getGenres()
    }
    
    // MARK: - TODO: -handle other states-
    
    func configView(with state: SearchViewModel.ViewState){
        
        if let customView = loadingView{
            customView.removeFromSuperview()
        }
        
        switch state {
        case .populated(_):
            self.tableView.reloadData()
        default:
            self.buildLoadingView()
            self.view.addSubview( loadingView )
        }
    }
    
    func buildLoadingView() {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .darkGray
        activityIndicator.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
        
        loadingView = UIView(frame: self.view.frame)
        loadingView.backgroundColor = .white
        
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func clearResults() {
        guard let controller = searchController.searchResultsController as? ResultsSearchViewController else { return }
        controller.viewModel.clearShows()
    }
    
    func search(for query: String) {
        guard let controller = searchController.searchResultsController as? ResultsSearchViewController else { return }
        controller.viewModel.searchShows(for: query, page: 1)
    }
    
    //MARK: - Nagivation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showTvShowListSegue" {
            guard let toController = segue.destination as? TVShowListViewController else { return }
            let genre = sender as! Int
            toController.viewModel = viewModel.buildMovieListViewModel(for: genre)
        }
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

//MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewState.value.currentEpisodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreViewCell", for: indexPath) as! GenreViewCell
        cell.genre = viewModel.genres[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let genre = viewModel.genres[indexPath.row]
        if let id = genre.id{
            performSegue(withIdentifier: "showTvShowListSegue", sender: id)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

//MARK: - ResultsSearchViewControllerDelegate

extension SearchViewController: ResultsSearchViewControllerDelegate {
    
    func resultsSearchViewController(_ resultsSearchViewController: ResultsSearchViewController, didSelectedMovie movie: Int) {
        handle(movie)
    }
}

//MARK: - Navigation

extension SearchViewController {
    
    // MARK: - TODO Handle Route
    
    func handle(_ route: Int?) {
        guard let identifier = route else { return }
        let detailController = searchViewControllersFactory.makeTVShowDetailsViewController(with: identifier)
        navigationController?.pushViewController(detailController, animated: true)
    }
}

// MARK: - SearchViewControllersFactory

protocol SearchViewControllersFactory {
    
    func makeSearchResultsViewModel() -> ResultsSearchViewModel
    
    func makeTVShowDetailsViewController(with identifier: Int) -> UIViewController
}
