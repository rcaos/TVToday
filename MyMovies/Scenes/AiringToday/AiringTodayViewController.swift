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
    
    //MARK: - SetupViewModel
    func setupViewModel(){
        //Binding
        viewModel.viewState.bindAndFire({ state in
            DispatchQueue.main.async {
                self.configTable(with: state)
                self.tableView.reloadData()
            }
        })
        
        viewModel.getShows()
    }
    
    func configTable(with state: AiringTodayViewModel.ViewState){
        switch state {
        case .populated(_):
            self.tableView.tableFooterView = UIView()
            self.tableView.separatorStyle = .singleLine
        default:
            self.tableView.tableFooterView = buildLoadingView()
            self.tableView.separatorStyle = .none
        }
    }
    
    func buildLoadingView() -> UIView{
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .darkGray
        activityIndicator.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
        
        let containerView = UIView(frame: self.view.frame)
        containerView.backgroundColor = .white
        
        activityIndicator.center = containerView.center
        containerView.addSubview(activityIndicator)
        
        self.view.addSubview(containerView)
        
        activityIndicator.startAnimating()
        
        return containerView
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTVShowDetail"{
            let showID = sender as! Int
            let controller = segue.destination as! TVShowDetailViewController
            controller.idShow = showID
        }
    }
}

//MARK: - DataSource, Delegate
extension AiringTodayViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewState.value.currentEpisodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowViewCell", for: indexPath) as! TVShowViewCell
        cell.viewModel = viewModel.getModelFor(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idSelected = viewModel.viewState.value.currentEpisodes[indexPath.row].id
        performSegue(withIdentifier: "ShowTVShowDetail", sender: idSelected)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
