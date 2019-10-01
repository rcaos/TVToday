//
//  DefaultSeasonTableViewController.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

private let reuseIdentifierForEpisode = "identifierForEpisodeSeason"
private let reuseIdentifierForSeasons = "identifierForSeason"

class DefaultSeasonTableViewController: UITableViewController {

    var viewModel:DefaultSeasonTableViewModel?{
        didSet{
            setupViewModel()
        }
    }
    
    var showDetail: TVShowDetailResult?{
        didSet{
            if let showDetail = showDetail,
                let idShow = showDetail.id{
                //viewModel = DefaultSeasonTableViewModel(show: idShow)
                viewModel = DefaultSeasonTableViewModel(showDetailResult: showDetail)
            }
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupTableHeaderView()
        print("viewDidLoad DefaultSeasonTableViewController")
    }
    
    deinit {
        print("deinit child DefaultSeasonTableViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.selectFirstSeason()
    }
    
    private func setupTable(){
        let nibName = UINib(nibName: "SeasonListTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: reuseIdentifierForEpisode)
        
        let nibColl = UINib(nibName: "SeasonEpisodeTableViewCell", bundle: nil)
        tableView.register(nibColl, forCellReuseIdentifier: reuseIdentifierForSeasons)
    }
    
    private func setupTableHeaderView(){
        let nib = UINib(nibName: "SeasonHeaderView", bundle: nil)
        let headerView = nib.instantiate(withOwner: nil, options: nil).first as! SeasonHeaderView
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 215)
        headerView.viewModel = viewModel?.buildHeaderViewModel()
        
        tableView.tableHeaderView = headerView
    }
    
    func buildActivityIndicator() -> UIView{
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
    
    func buildEmptyView() -> UIView{
        
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.height, height: 200)
        let nib = UINib(nibName: "EmptyView", bundle: nil)
        
        let emptyView = nib.instantiate(withOwner: nil, options: nil).first as! EmptyView
        emptyView.frame = frame
        
        return emptyView
    }
    
    func buildErrorView() -> UIView{
        
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.height, height: 200)
        let nib = UINib(nibName: "ErrorView", bundle: nil)
        
        let emptyView = nib.instantiate(withOwner: nil, options: nil).first as! ErrorView
        emptyView.frame = frame
        
        return emptyView
    }
    
    private func setupViewModel(){
        setupBindables()
        viewModel?.getFirstSeason()
    }
    
    private func setupBindables(){
        viewModel?.viewState.bindAndFire({[weak self] state in
            DispatchQueue.main.async {
                self?.configureView(with: state)
                self?.reloadSection(at: 1)
            }
        })
    }
    
    private func configureView(with state: DefaultSeasonTableViewModel.ViewState) {
        
        switch state {
        case .populated:
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .singleLine
        case .empty:
            tableView.tableFooterView = buildEmptyView()
            tableView.separatorStyle = .none
        case .error(_):
            tableView.tableFooterView = buildErrorView()
            //tableView.tableFooterView = CustomFooterView(message: error.description)
            tableView.separatorStyle = .none
        default:
            //Loading
            tableView.tableFooterView = buildActivityIndicator()
            tableView.separatorStyle = .none
        }
    }
    
    
    func reloadSection(at section: Int){
        print("\nSe actualizará Section para: \(section)")
        let index = IndexSet(integer: section)
//        print("Existen celdas?: \(tableView.numberOfRows(inSection: section))")
//        print("Cells for model?: \(viewModel?.viewState.value.currentEpisodes.count)")
        tableView.beginUpdates()
        tableView.reloadSections(index, with: .automatic)
        tableView.endUpdates()
    }

}

extension DefaultSeasonTableViewController{
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        
        if section == 0 {
            return 1
        }else{
            return viewModel.viewState.value.currentEpisodes.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            return makeCellForSeasonNumber(tableView, cellForRowAt: indexPath)
        }else{
            return makeCellForEpisode(tableView, cellForRowAt: indexPath)
        }
    }
    
    private func makeCellForSeasonNumber(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //print("Se pide Model para Season Number : \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierForSeasons, for: indexPath) as! SeasonEpisodeTableViewCell
        cell.viewModel = viewModel?.buildModelForSeasons()
        cell.delegate = self
        return cell
    }
    
    private func makeCellForEpisode(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierForEpisode, for: indexPath) as! SeasonListTableViewCell
        
        var msg = ""
        if let model = viewModel?.getModel(for: indexPath.row){
            cell.viewModel = model
            msg = "\(model.data?.value?.isEmpty)"
        }
        print("Se pide Model para Episode : \(indexPath), \(msg)")
        return cell
    }
    
}

extension DefaultSeasonTableViewController{
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 65
        }else{
            return 110
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DefaultSeasonTableViewController: SeasonEpisodeTableViewCellDelegate{
    
    func didSelectedSeason(at index: Int) {
        //print("-TableController: Se selecciono la celda: [\(index)]")
        //print("-Season Selected: \()")
        viewModel?.getSeason(at: index)
    }
    
}
