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
        
        navigationItem.title = "Airing Today"
        setupTable()
        TMDBClient.getAiringTodayShows(completion: handleAiringTodayShows(shows:error:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTable(){
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "TVShowViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "TVShowViewCell")
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
            controller.idShow = Model.todayShows[indexPath.row].id
        }
    }
}

extension AiringTodayViewController: UITableViewDataSource, UITableViewDelegate{
    
    //MARK: DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.todayShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowViewCell", for: indexPath) as! TVShowViewCell
        cell.show = Model.todayShows[indexPath.row]
        return cell
    }
    
    //Mark: Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowTVShowDetail", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
