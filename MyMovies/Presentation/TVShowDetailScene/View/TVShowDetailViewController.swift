//
//  TVShowDetailViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class TVShowDetailViewController: UITableViewController, StoryboardInstantiable {
    
    var viewModel: TVShowDetailViewModel?
    
    private var showDetailsViewControllersFactory: TVShowDetailViewControllersFactory!
    
    @IBOutlet weak private var backDropImage: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var yearsRelease: UILabel!
    @IBOutlet weak private var durationLabel: UILabel!
    @IBOutlet weak private var genreLabel: UILabel!
    @IBOutlet weak private var numberOfEpisodes: UILabel!
    @IBOutlet weak private var posterImage: UIImageView!
    @IBOutlet weak private var overViewLabel: UITextView!
    @IBOutlet weak private var scoreLabel: UILabel!
    @IBOutlet weak private var countVoteLabel: UILabel!
    
    private var loadingView: UIView!
    
    // MARK: - TODO, cambiar por protocol del ViewModel
    
    static func create(with viewModel: TVShowDetailViewModel,
                       showDetailsViewControllersFactory: TVShowDetailViewControllersFactory) -> TVShowDetailViewController {
        let controller = TVShowDetailViewController.instantiateViewController()
        controller.viewModel = viewModel
        controller.showDetailsViewControllersFactory = showDetailsViewControllersFactory
        return controller
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        print("deinit TVShowDetailViewController")
    }
    
    //MARK: - SetupViewModel
    
    private func setupViewModel() {
        setupBindables()
        viewModel?.getShowDetails()
    }
    
    private func setupBindables() {
        
        viewModel?.viewState.observe(on: self) {[weak self] state in
            self?.configView(with: state)
        }
        
        viewModel?.route.observe(on: self) { [weak self] route in
            self?.handle(route)
        }
        
        //Poster and BackDrop
        viewModel?.dropData.observe(on: self) { [weak self] data in
            if let data = data {
                self?.backDropImage.image = UIImage(data: data)
            }
        }
        
        viewModel?.posterData.observe(on: self) { [weak self] data in
            if let data = data {
                self?.posterImage.image = UIImage(data: data)
            }
        }
    }
    
    //TODO: - handle other states -
    func configView(with state: TVShowDetailViewModel.ViewState) {
        
        if let customView = loadingView{
            customView.removeFromSuperview()
        }
        
        switch state {
        case .populated:
            self.setupUI()
        default:
            self.buildLoadingView()
            self.view.addSubview( loadingView )
        }
    }
    
    func buildLoadingView() {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .darkGray
        activityIndicator.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        
        loadingView = UIView(frame: self.view.frame)
        loadingView.backgroundColor = .white
        
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func setupUI() {
        guard let viewModel = viewModel else { return }
        
        nameLabel.text = viewModel.nameShow
        yearsRelease.text = viewModel.yearsRelease
        
        durationLabel.text = viewModel.duration
        genreLabel.text = viewModel.genre
        
        numberOfEpisodes.text = viewModel.numberOfEpisodes
        overViewLabel.text = viewModel.overView
        scoreLabel.text = viewModel.score
        countVoteLabel.text = viewModel.countVote
    }
}

extension TVShowDetailViewController {
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 1{
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 1{
            viewModel?.showSeasonList()
            return indexPath
        }else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let percentFirstRow = CGFloat(0.45)
        let fixedSecondRow = CGFloat(50.0)
        
        let totalHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let restOfHeight = (totalHeight * (1-percentFirstRow) ) - fixedSecondRow
        
        var heightrow = CGFloat(0.0)
        
        if indexPath.row == 0{
            heightrow =  totalHeight * ( percentFirstRow )
        }else if indexPath.row == 1{
            heightrow = fixedSecondRow
        }else if indexPath.row == 2{
            heightrow = restOfHeight * 0.65
        }else if indexPath.row == 3{
            heightrow = restOfHeight * 0.35
        }else{
            heightrow = 0
        }
        return CGFloat(heightrow)
    }
}

extension TVShowDetailViewController {
    
    //MARK: - TODO TVShowDetailViewModelRoute
    func handle(_ route: TVShowDetailViewModelRoute) {
        
        switch route {
        case .initial: break
            
        case .showSeasonsList(let tvshowResult):
            let seasonsController = showDetailsViewControllersFactory .makeSeasonsListViewController(with: tvshowResult)
            
            navigationController?.pushViewController(seasonsController, animated: true)
        }
    }
}

// MARK: - TVShowDetailViewControllersFactory

protocol TVShowDetailViewControllersFactory {
    
    func makeSeasonsListViewController(with result: TVShowDetailResult) -> UIViewController
}
