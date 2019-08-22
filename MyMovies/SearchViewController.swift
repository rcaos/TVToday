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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search TV Shows"

        TMDBClient.getGenresTVShows(completion: handleSearchGenre(genres:error:))
    }
    
    func handleSearchGenre(genres: [Genre]?, error: Error?){
        if let genres = genres{
            Model.genresShows = genres
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.genresShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        cell.genre = Model.genresShows[indexPath.row]
        return cell
    }
}
