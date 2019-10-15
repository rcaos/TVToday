//
//  ResultsSearchViewController.swift
//  MyTvShows
//
//  Created by Jeans on 8/26/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

protocol ResultsSearchViewControllerDelegate: class{
    func resultsSearchViewController(_ resultsSearchViewController: ResultsSearchViewController, didSelectedMovie movie: Int )
}

class ResultsSearchViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var viewModel = ResultsSearchViewModel()
    var delegate:ResultsSearchViewControllerDelegate!
    
    var loadingView: UIView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        setupViewModel()
    }
    
    func setupTable(){
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "TVShowViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "TVShowViewCell")
    }
    
    //MARK: - SetupViewModel
    func setupViewModel(){
        
        //Binding
        viewModel.viewState.bind({[unowned self] state in
            DispatchQueue.main.async {
                self.configView(with: state)
            }
        })
    }
    
    func configView(with state: ResultsSearchViewModel.ViewState){
        
        if let customView = loadingView{
            customView.removeFromSuperview()
        }
        
        switch state {
        case .populated(_):
            self.tableView.reloadData()
        default:
            self.buildLoadingView()
            self.view.addSubview( loadingView )
        }
    }
    
    func buildLoadingView(){
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .darkGray
        activityIndicator.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
        
        loadingView = UIView(frame: self.view.frame)
        loadingView.backgroundColor = .white
        
        activityIndicator.center = loadingView.center
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}

//MARK: - UITableViewDataSource
extension ResultsSearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewState.value.currentEpisodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowViewCell", for: indexPath) as! TVShowViewCell
        cell.viewModel = viewModel.models[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ResultsSearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedShow = viewModel.shows[indexPath.row]
        delegate?.resultsSearchViewController(self, didSelectedMovie: selectedShow.id)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
