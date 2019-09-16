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
        
        setupTable()
        TMDBClient.getPopularShows(completion: handlePopularShows(shows:error:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTable(){
        let nibName = UINib(nibName: "TVShowViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "TVShowViewCell")
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
            controllerTo.idShow = Model.popularShows[indexPath.row].id
        }
    }
}

extension PopularShowsViewController{
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.popularShows.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowViewCell", for: indexPath) as! TVShowViewCell
        //cell.show = Model.popularShows[indexPath.row]
        return cell
    }
    
    //MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowTVShowDetail", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
