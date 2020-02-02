//
//  TVShowListViewController.swift
//  MyTvShows
//
//  Created by Jeans on 8/26/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class TVShowListViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: TVShowListViewModel!
    
    private var showsListViewControllersFactory: TVShowListViewControllersFactory!
    
    var loadingView: UIView!
    
    static func create(with viewModel: TVShowListViewModel,
                       showsListViewControllersFactory: TVShowListViewControllersFactory) -> TVShowListViewController {
        let controller = TVShowListViewController.instantiateViewController()
        controller.viewModel = viewModel
        controller.showsListViewControllersFactory = showsListViewControllersFactory
        return controller
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViewModel()
    }
    
    deinit {
        print("deinit TVShowListViewController")
    }
    
    //MARK: - SetupView
    
    func setupUI() {
        setupTable()
    }
    
    // MARK: - SetupTable
    
    func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "TVShowViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "TVShowViewCell")
        
        buildLoadingView()
    }
    
    // MARK: - SetupViewModel
    
    func setupViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.viewState.observe(on: self) {[weak self] state in
            self?.configView(with: state)
        }
        
        viewModel.getShows(for: 1)
    }
    
    func configView(with state: SimpleViewState<TVShow>) {
        switch state {
        case .populated(_):
            self.tableView.reloadData()
        case .paging(_, _):
            self.tableView.reloadData()
            self.tableView.tableFooterView = loadingView
        default:
            self.tableView.tableFooterView = loadingView
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

// MARK: - UITableViewDataSource

extension TVShowListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.viewState.value.currentEntities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { fatalError() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowViewCell", for: indexPath) as! TVShowViewCell
        cell.viewModel = viewModel.getModelFor(indexPath.row)
        
        if case .paging(_, let nextPage) = viewModel.viewState.value,
            indexPath.row == viewModel.viewState.value.currentEntities.count - 1 {
            viewModel.getShows(for: nextPage)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TVShowListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let idToSend = viewModel?.shows[indexPath.row].id
        handle(idToSend)
    }
}

// MARK: - Navigation

extension TVShowListViewController {
    
    // MARK: - TODO Handle Navigation
    
    func handle(_ route: Int?) {
        guard let identifier = route else { return }
        let detailController =  showsListViewControllersFactory.makeTVShowDetailsViewController(with: identifier)
        navigationController?.pushViewController(detailController, animated: true)
    }
}

// MARK: - TVShowListViewControllersFactory

protocol TVShowListViewControllersFactory {
    
    func makeTVShowDetailsViewController(with identifier: Int) -> UIViewController
}
