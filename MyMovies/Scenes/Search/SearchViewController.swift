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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Search TV Shows"

        TMDBClient.getGenresTVShows(completion: handleSearchGenre(genres:error:))
        
        setupTable()
        setupSearchBar()
    }
    
    //MARK: - SetupTable
    func setupTable(){
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "GenreViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "GenreViewCell")
    }
    
    //MARK: - Setup UI
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
    
    //MARK: - Networking
    func handleSearchGenre(genres: [Genre]?, error: Error?){
        if let genres = genres{
            Model.genresShows = genres
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func handleSearchShow(shows: [TVShow]?, error: Error?){
        if let shows = shows{
            guard let controller = searchController.searchResultsController as? ResultsSearchViewController else { return }
            
            DispatchQueue.main.async {
                controller.tvShowsResults = shows
            }
        }
    }
    
    func clearResults(){
        guard let controller = searchController.searchResultsController as? ResultsSearchViewController else { return }
        if let _ = controller.tvShowsResults{
            controller.tvShowsResults.removeAll()
        }
    }
    
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
            TMDBClient.search(for: query, completion: handleSearchShow(shows:error:) )
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearResults()
    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.genresShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreViewCell", for: indexPath) as! GenreViewCell
        cell.genre = Model.genresShows[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let genre = Model.genresShows[indexPath.row]
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
