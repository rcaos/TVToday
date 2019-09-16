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
    var viewModel = ResultsSearchViewModel()
    var delegate:ResultsSearchViewControllerDelegate!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        setupViewModel()
    }
    
    func setupTable(){
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "TVShowViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "TVShowViewCell")
    }
    
    //MARK: - SetupViewModel
    func setupViewModel(){
        
        //Binding
        viewModel.reloadData.bindAndFire({[unowned self] isReload in
            if isReload{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print("Se actualizó Results ViewController..")
                }
            }
        })
    }
}

//MARK: - UITableViewDataSource
extension ResultsSearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowViewCell", for: indexPath) as! TVShowViewCell
        cell.viewModel = viewModel.showCells[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ResultsSearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedShow = viewModel.shows[indexPath.row]
        delegate?.resultsSearchViewController(self, didSelectedMovie: selectedShow.id)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
