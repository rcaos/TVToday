//
//  AiringTodayTableViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class PopularShowsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Popular Shows"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        TMDBClient.getPopularShows(completion: handleGetPopularShows(shows:error:) )
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func handleGetPopularShows(shows :[TVShow]?, error :Error?){
        if let shows = shows{
            Model.popularShows.append(contentsOf: shows)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

extension PopularShowsTableViewController{
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AiringCell", for: indexPath) as! AiringTodayTableViewCell
        
        cell.tvShow = Model.popularShows[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.popularShows.count
    }
}
