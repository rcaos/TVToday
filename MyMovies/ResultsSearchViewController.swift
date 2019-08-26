//
//  ResultsSearchViewController.swift
//  MyTvShows
//
//  Created by Jeans on 8/26/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

protocol ResultsSearchViewControllerDelegate: class{
    func resultsSearchViewController(_ resultsSearchViewController: ResultsSearchViewController, didSelectedMovie movie: Int )
}

class ResultsSearchViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var tvShowsResults:[TVShow]!{
        didSet{
            tableView.reloadData()
        }
    }
    
    var delegate:ResultsSearchViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//MARK: - UITableViewDataSource
extension ResultsSearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tvShowsResults = tvShowsResults else{ return 0}
        return tvShowsResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellListResult", for: indexPath)
        cell.textLabel?.text = tvShowsResults[indexPath.row].name
        cell.detailTextLabel?.text = String(tvShowsResults[indexPath.row].voteAverage)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ResultsSearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedShow = tvShowsResults[indexPath.row]
        delegate?.resultsSearchViewController(self, didSelectedMovie: selectedShow.id)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
