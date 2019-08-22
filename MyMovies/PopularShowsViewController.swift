//
//  PupularShowsViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class PopularShowsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Popular TV Shows"
        
        TMDBClient.getPopularShows(completion: handlePopularShows(shows:error:))
    }
    
    func handlePopularShows(shows: [TVShow]?, error: Error?){
        if let shows = shows{
            Model.popularShows = shows
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

extension PopularShowsViewController{
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.popularShows.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AiringCell", for: indexPath) as! PopularShowsCell
        
        cell.tvShow = Model.popularShows[indexPath.row]
        return cell
    }
}
