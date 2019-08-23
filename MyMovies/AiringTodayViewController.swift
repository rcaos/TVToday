//
//  AiringTodayViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class AiringTodayViewController: UIViewController{
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "Airing Today"

        TMDBClient.getAiringTodayShows(completion: handleAiringTodayShows(shows:error:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func handleAiringTodayShows(shows: [TVShow]?, error: Error?){
        if let shows = shows{
            Model.todayShows = shows
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTVShowDetail"{
            
            let indexPath = sender as! IndexPath
            
            let controller = segue.destination as! TVShowDetailViewController
            controller.tvShowGeneral = Model.todayShows[indexPath.row]
        }
    }
}

extension AiringTodayViewController: UITableViewDataSource, UITableViewDelegate{
    
    //MARK: DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.todayShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AiringTodayCell", for: indexPath) as! AiringTodayCell
        
        cell.show = Model.todayShows[indexPath.row]
        return cell
    }
    
    //Mark: Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowTVShowDetail", sender: indexPath)
        //performSegue(withIdentifier: "temporalSegue", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
