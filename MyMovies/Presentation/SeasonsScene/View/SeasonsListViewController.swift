//
//  SeasonsListViewController.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

private let reuseIdentifierForEpisode = "identifierForEpisodeSeason"
private let reuseIdentifierForSeasons = "identifierForSeason"

class SeasonsListViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var tableView: UITableView!

    private var viewModel: SeasonsListViewModel!
    private var seasonsListViewControllers: SeasonsListViewControllersFactory!
    
    // MARK: - TODO, cambiar por protocol del ViewModel
    
    static func create(with viewModel: SeasonsListViewModel,
                       seasonsListViewControllers: SeasonsListViewControllersFactory) -> SeasonsListViewController {
        let controller = SeasonsListViewController.instantiateViewController()
        controller.viewModel = viewModel
        controller.seasonsListViewControllers = seasonsListViewControllers
        return controller
    }
        
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupTableHeaderView()
        setupViewModel()
    }
    
    deinit {
        print("deinit child DefaultSeasonTableViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.selectFirstSeason()
    }
    
    private func setupTable() {
        let nibName = UINib(nibName: "SeasonListTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: reuseIdentifierForEpisode)
        
        let nibColl = UINib(nibName: "SeasonEpisodeTableViewCell", bundle: nil)
        tableView.register(nibColl, forCellReuseIdentifier: reuseIdentifierForSeasons)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupTableHeaderView() {
        let nib = UINib(nibName: "SeasonHeaderView", bundle: nil)
        let headerView = nib.instantiate(withOwner: nil, options: nil).first as! SeasonHeaderView
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 150)
        headerView.viewModel = viewModel.buildHeaderViewModel()
        
        tableView.tableHeaderView = headerView
    }
    
    func buildActivityIndicator() -> UIView {
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
    
    func buildEmptyView() -> UIView {
        
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.height, height: 200)
        let nib = UINib(nibName: "EmptyView", bundle: nil)
        
        let emptyView = nib.instantiate(withOwner: nil, options: nil).first as! EmptyView
        emptyView.frame = frame
        
        return emptyView
    }
    
    func buildErrorView() -> UIView {
        
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.height, height: 200)
        let nib = UINib(nibName: "ErrorView", bundle: nil)
        
        let emptyView = nib.instantiate(withOwner: nil, options: nil).first as! ErrorView
        emptyView.frame = frame
        
        return emptyView
    }
    
    private func setupViewModel() {
        setupBindables()
        viewModel.getFirstSeason()
    }
    
    private func setupBindables() {
        viewModel.viewState.bindAndFire({[weak self] state in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.configureView(with: state)
                strongSelf.reloadSection(at: 1)
            }
        })
    }
    
    private func configureView(with state: SeasonsListViewModel.ViewState) {
        
        switch state {
        case .populated:
            print("Populated state")
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .singleLine
        case .empty:
            tableView.tableFooterView = buildEmptyView()
            tableView.separatorStyle = .none
        case .error(_):
            tableView.tableFooterView = buildErrorView()
            tableView.separatorStyle = .none
        default:
            //Loading
            tableView.tableFooterView = buildActivityIndicator()
            tableView.separatorStyle = .none
        }
    }
    
    func reloadSection(at section: Int) {
        let index = IndexSet(integer: section)
        tableView.beginUpdates()
        tableView.reloadSections(index, with: .automatic)
        tableView.endUpdates()
    }
}

extension SeasonsListViewController: UITableViewDataSource {
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return viewModel.viewState.value.currentEpisodes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            return makeCellForSeasonNumber(tableView, cellForRowAt: indexPath)
        }else{
            return makeCellForEpisode(tableView, cellForRowAt: indexPath)
        }
    }
    
    private func makeCellForSeasonNumber(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierForSeasons, for: indexPath) as! SeasonEpisodeTableViewCell
        cell.viewModel = viewModel.buildModelForSeasons()
        cell.delegate = self
        return cell
    }
    
    private func makeCellForEpisode(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierForEpisode, for: indexPath) as! SeasonListTableViewCell
        
        if let model = viewModel.getModel(for: indexPath.row){
            cell.viewModel = model
        }
        return cell
    }
    
}

extension SeasonsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 65
        }else{
            return 110
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SeasonsListViewController: SeasonEpisodeTableViewCellDelegate {
    
    func didSelectedSeason(at index: Int) {
        viewModel.getSeason(at: index)
    }
}

// MARK: - AiringTodayViewControllersFactory

protocol SeasonsListViewControllersFactory {
    
}
