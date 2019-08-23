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
        navigationItem.title = "Popular TV Shows"
        
        TMDBClient.getPopularShows(completion: handlePopularShows(shows:error:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func handlePopularShows(shows: [TVShow]?, error: Error?){
        if let shows = shows{
            Model.popularShows = shows
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTVShowDetail"{
            let indexPath =  sender as! IndexPath
            
            let controllerTo = segue.destination as! TVShowDetailViewController
            controllerTo.tvShowGeneral  = Model.popularShows[indexPath.row]
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
    
    //MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowTVShowDetail", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
