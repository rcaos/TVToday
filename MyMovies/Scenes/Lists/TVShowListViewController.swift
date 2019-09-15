//
//  TVShowListViewController.swift
//  MyTvShows
//
//  Created by Jeans on 8/26/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class TVShowListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var idGenre: Int!
    private var tvShows:[TVShow]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        if let genre = idGenre{
            TMDBClient.listTVShows(by: genre, completion: handleShowsResult(shows:error:))
        }
    }
    
    func setupTable(){
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "TVShowViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "TVShowViewCell")
    }
    
    func handleShowsResult( shows: [TVShow]?, error: Error?){
        if let shows = shows{
            self.tvShows = shows
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tvShowDetailSegue"{
            if let toController = segue.destination as? TVShowDetailViewController{
                toController.idShow = sender as? Int
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension TVShowListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let shows = tvShows else{ return 0}
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowViewCell", for: indexPath) as! TVShowViewCell
        guard let _ = tvShows else { return UITableViewCell() }
        cell.show = tvShows[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate
extension TVShowListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "tvShowDetailSegue", sender: tvShows[indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
