//
//  PupularShowsViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class PopularsViewController: UITableViewController, StoryboardInstantiable {

    var viewModel:PopularViewModel!
    private var popularViewControllersFactory: PopularViewControllersFactory!
    
    var loadingView: UIView!
    
    static func create(with viewModel: PopularViewModel,
                       popularViewControllersFactory: PopularViewControllersFactory) -> PopularsViewController {
        let controller = PopularsViewController.instantiateViewController()
        controller.viewModel = viewModel
        controller.popularViewControllersFactory = popularViewControllersFactory
        return controller
    }
    
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
    
    func setupUI() {
        navigationItem.title = "Popular TV Shows"
        setupTable()
    }
    
    //MARK: - SetupTable
    
    func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "TVShowViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "TVShowViewCell")
        
        buildLoadingView()
    }
    
    //MARK: - SetupUI
    
    func setupViewModel() {
        viewModel.viewState.observe(on: self) { [weak self] state in
            self?.configView(with: state)
        }
        viewModel.getShows(for: 1)
    }
    
    func configView(with state: SimpleViewState<TVShow>) {
        
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
    
    func buildLoadingView() {
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
}

extension PopularsViewController{
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewState.value.currentEntities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowViewCell", for: indexPath) as! TVShowViewCell
        cell.viewModel = viewModel.getModelFor(indexPath.row)
        
        if case .paging(_, let nextPage) = viewModel.viewState.value ,
            indexPath.row == viewModel.viewState.value.currentEntities.count - 1  {
            viewModel.getShows(for: nextPage)
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let idShow = viewModel.shows[indexPath.row].id!
        handle(idShow)
    }
}

//MARK: - Navigation

extension PopularsViewController {

    // MARK: - Handle Navigation
    
    func handle(_ route: Int?) {
        guard let identifier = route else { return }
        let detailController = popularViewControllersFactory.makeTVShowDetailsViewController(with: identifier)
        navigationController?.pushViewController(detailController, animated: true)
    }
}

// MARK: - PopularViewControllersFactory

protocol PopularViewControllersFactory {
    
    func makeTVShowDetailsViewController(with identifier: Int) -> UIViewController
}

