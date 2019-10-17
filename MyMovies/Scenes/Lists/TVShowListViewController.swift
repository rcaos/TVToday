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
    
    var viewModel: TVShowListViewModel? {
        didSet {
            setupViewModel()
        }
    }
    
    var loadingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    deinit {
        print("deinit TVShowListViewController")
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
        
        buildLoadingView()
    }
    
    //MARK: - SetupViewModel
    func setupViewModel(){
        guard let viewModel = viewModel else { return }
        
        //Binding
        viewModel.viewState.bindAndFire({[unowned self] state in
            DispatchQueue.main.async {
                self.configView(with: state)
            }
        })
        
        viewModel.getMoviesForGenre(from: 1)
    }
    
    func configView(with state: TVShowListViewModel.ViewState){
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
        if segue.identifier == "tvShowDetailSegue"{
            if let toController = segue.destination as? TVShowDetailViewController{
                let idShow = sender as! Int
                toController.viewModel = viewModel?.buildShowDetailViewModel(for: idShow)
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension TVShowListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.viewState.value.currentEpisodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { fatalError() }

        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowViewCell", for: indexPath) as! TVShowViewCell
        cell.viewModel = viewModel.models[indexPath.row]
        
        if case .paging(_, let nextPage) = viewModel.viewState.value,
            indexPath.row == viewModel.viewState.value.currentEpisodes.count - 1 {
            viewModel.getMoviesForGenre(from: nextPage)
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension TVShowListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idToSend = viewModel?.shows[indexPath.row].id
        
        performSegue(withIdentifier: "tvShowDetailSegue", sender: idToSend)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
