//
//  PupularShowsViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class PopularsViewController: UITableViewController {

    var viewModel = PopularViewModel()
    
    var loadingView: UIView!
    
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
        navigationItem.title = "Popular TV Shows"
        setupTable()
    }
    
    //MARK: - SetupTable
    func setupTable(){
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "TVShowViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "TVShowViewCell")
        
        buildLoadingView()
    }
    
    //MARK: - SetupUI
    func setupViewModel(){
        
        //Binding
        viewModel.viewState.bindAndFire({ [unowned self] state in
            DispatchQueue.main.async {
                self.configView(with: state)
            }
        })
        
        viewModel.getShows(for: 1)
    }
    
    func configView(with state: PopularViewModel.ViewState){
        
        switch state {
        case .populated(_) :
            self.tableView.reloadData()
            self.tableView.tableFooterView = UIView()
        case .paging(_, _) :
            self.tableView.reloadData()
            self.tableView.tableFooterView = loadingView
        case .loading :
            self.tableView.tableFooterView = loadingView
        default:
            print("Default State")
        }
    }
    
    func buildLoadingView(){
        let defaultFrame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
        
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .darkGray
        activityIndicator.frame = defaultFrame
        
        loadingView = UIView(frame: defaultFrame)
        loadingView.backgroundColor = .white
        
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTVShowDetail"{
            let indexPath =  sender as! IndexPath
            let idShow = viewModel.shows[indexPath.row].id!
            
            let controllerTo = segue.destination as! TVShowDetailViewController
            controllerTo.viewModel = viewModel.buildShowDetailViewModel(for: idShow)
        }
    }
}

extension PopularsViewController{
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewState.value.currentEpisodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowViewCell", for: indexPath) as! TVShowViewCell
        cell.viewModel = viewModel.models[indexPath.row]
        
        if case .paging(_, let nextPage) = viewModel.viewState.value ,
            indexPath.row == viewModel.viewState.value.currentEpisodes.count - 1  {
            viewModel.getShows(for: nextPage)
        }
        
        return cell
    }
    
    //MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowTVShowDetail", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
