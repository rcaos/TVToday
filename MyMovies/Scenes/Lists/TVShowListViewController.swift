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
    
    var viewModel = TVShowListViewModel()
    var idGenre: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViewModel()
    }
    
    //MARK: - SetupView
    func setupUI(){
        setupTable()
    }
    
    //MARK: - SetupTable
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
                    print("Se actualizó Data en ShowLists..")
                }
            }
        })
        
        if let genre = idGenre{
            viewModel.getGenres(by: genre)
        }
    }
    
    //MARK: - Navigation
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
        return viewModel.shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowViewCell", for: indexPath) as! TVShowViewCell
        cell.viewModel = viewModel.showCells[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate
extension TVShowListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idToSend = viewModel.shows[indexPath.row].id
        
        performSegue(withIdentifier: "tvShowDetailSegue", sender: idToSend)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
