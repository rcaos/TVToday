//
//  SearchViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController{
    
    @IBOutlet var tableView: UITableView!
    var searchController:UISearchController!
    var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - SetupView
    func setupUI(){
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Search TV Shows"
        
        setupTable()
        setupSearchBar()
        setupViewModel()
    }
    
    //MARK: - SetupTable
    func setupTable(){
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "GenreViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "GenreViewCell")
    }
    
    //MARK: - SetupSearchBar
    func setupSearchBar(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toController = storyboard.instantiateViewController(withIdentifier: "searchResults")
        
        guard let resultsController = toController as? ResultsSearchViewController else{ return }
        resultsController.delegate = self
        
        //Así se cae @@
        //let resultsController = ResultsSearchViewController()
        
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
    func setupViewModel(){
        
        //Binding
        viewModel.reloadData.bindAndFire({[unowned self] isReload in
            if isReload{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print("Se actualizó Data en Genres..")
                }
            }
        })
        
        viewModel.getGenres()
    }
    
    func clearResults(){
        guard let controller = searchController.searchResultsController as? ResultsSearchViewController else { return }
        controller.viewModel.clearShows()
    }
    
    func search(for query: String){
        guard let controller = searchController.searchResultsController as? ResultsSearchViewController else { return }
        controller.viewModel.searchShows(for: query)
    }
    
    //MARK: - Nagivation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTVShowDetail"{
            guard let toController = segue.destination as? TVShowDetailViewController else { return }
            toController.idShow = sender as? Int
            
        }else if segue.identifier == "showTvShowListSegue"{
            guard let toController = segue.destination as? TVShowListViewController else { return }
            toController.idGenre = sender as? Int
        }
    }
}

//MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            search(for: query)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearResults()
    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreViewCell", for: indexPath) as! GenreViewCell
        cell.genre = viewModel.genres[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let genre = viewModel.genres[indexPath.row]
        if let id = genre.id{
            performSegue(withIdentifier: "showTvShowListSegue", sender: id)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

//MARK: - ResultsSearchViewControllerDelegate
extension SearchViewController: ResultsSearchViewControllerDelegate{
    func resultsSearchViewController(_ resultsSearchViewController: ResultsSearchViewController, didSelectedMovie movie: Int) {
        performSegue(withIdentifier: "ShowTVShowDetail", sender: movie)
    }
}
