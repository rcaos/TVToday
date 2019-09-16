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
    
    lazy private var viewModel:AiringTodayViewModel = AiringTodayViewModel()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: - SetupView
    func setupUI(){
        navigationItem.title = "Airing Today"
        setupTable()
    }
    
    //MARK: - SetupTable
    func setupTable(){
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "TVShowViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "TVShowViewCell")
    }
    
    //MARK: - SetupUI
    func setupViewModel(){
        
        //Binding
        viewModel.reloadData.bindAndFire({[unowned self] isReload in
            if isReload{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print("Se actualizó Data en AiringTodayVC..")
                }
            }
        })
        viewModel.getShows()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTVShowDetail"{
            let indexPath = sender as! IndexPath
            
            let controller = segue.destination as! TVShowDetailViewController
            controller.idShow = viewModel.shows[indexPath.row].id
        }
    }
}

//MARK: - DataSource, Delegate
extension AiringTodayViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowViewCell", for: indexPath) as! TVShowViewCell
        cell.viewModel = viewModel.showCells[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowTVShowDetail", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
