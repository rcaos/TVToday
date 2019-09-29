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
    
//    override func loadView() {
//        tableView.backgroundView = activityIndicator
//    }
    
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
    
    private func setupViewModel(){
        setupBindables()
        viewModel?.getFirstSeason()
    }
    
    private func setupBindables(){
        
        viewModel?.reloadCollection = {[weak self] in
            DispatchQueue.main.async {
                self?.reloadCollection()
            }
        }
        
        viewModel?.reloadSection = {[weak self] section in
            DispatchQueue.main.async {
                self?.reloadSection(at: section)
            }
        }
        
        viewModel?.reloadCell = { [weak self] index in
            DispatchQueue.main.async {
                self?.reloadCells(at: index)
            }
        }
    }
    
    //FIXME: - Reload Image Cells -
    //Heap corruption detected
    //Guard value 22
    //First select season 1
    //Luego select season 9
    func reloadCells(at indexPath: Int){
        let index = IndexPath(row: indexPath, section: 1)

        if let indexs =  tableView.indexPathsForVisibleRows,
            indexs.contains(index){

            print("\nSe actualizará solo la celda...\(index)")
            tableView.reloadRows(at: [index], with: .none)
        }
    }
    
    func reloadCollection(){
//        print("\nSe actualizará Section para CollectionView")
//        let index = IndexSet(integer: 0)
//        tableView.reloadSections(index, with: .none)
    }
    
    func reloadSection(at section: Int){
        print("\nSe actualizará Section para: \(section)")
        let index = IndexSet(integer: section)

        print("Existen celdas?: \(tableView.numberOfRows(inSection: section))")
        print("Cells for model?: \(viewModel?.numberOfEpisodes)")

        if let visible = viewModel?.numberOfEpisodes{
            if visible == tableView.numberOfRows(inSection: section){

                let index = IndexSet(integer: section)
                tableView.reloadSections(index, with: .none)
                return
            }
        }

        tableView.beginUpdates()
        tableView.deleteSections(index, with: .none)
        tableView.insertSections(index, with: .none)

        //Jajaj tiene que ser el mismo # de elementos
        //tableView.reloadSections(index, with: .automatic)
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
            return viewModel.numberOfEpisodes
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
            msg = "\(model.data?.isEmpty)"
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
