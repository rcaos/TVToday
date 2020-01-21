//
//  ResultsSearchViewController.swift
//  MyTvShows
//
//  Created by Jeans on 8/26/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

protocol ResultsSearchViewControllerDelegate: class {
    func resultsSearchViewController(_ resultsSearchViewController: ResultsSearchViewController, didSelectedMovie movie: Int )
}

class ResultsSearchViewController: UIViewController {
    
    var resultView: ResultListView = ResultListView()
    
    var delegate:ResultsSearchViewControllerDelegate?
    
    var loadingView: UIView!
    
    var viewModel: ResultsSearchViewModel
    
    init(viewModel: ResultsSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        super.loadView()
        view = resultView
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        setupViewModel()
    }
    
    func setupTable() {
        resultView.tableView.dataSource = self
        resultView.tableView.delegate = self
        
        let nibName = UINib(nibName: "TVShowViewCell", bundle: nil)
        resultView.tableView.register(nibName, forCellReuseIdentifier: "TVShowViewCell")
        
        buildLoadingView()
    }
    
    //MARK: - SetupViewModel
    
    func setupViewModel() {
        
        viewModel.viewState.observe(on: self) {[weak self] state in
            self?.configView(with: state)
        }
    }
    
    func configView(with state: SimpleViewState<TVShow>) {
        
        let tableView = resultView.tableView
        
        switch state {
        case .populated(_):
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .singleLine
            tableView.reloadData()
        case .empty:
            tableView.tableFooterView = buildEmptyView()
            tableView.separatorStyle = .none
        case .paging(_, _):
            tableView.tableFooterView = loadingView
            tableView.separatorStyle = .singleLine
            tableView.reloadData()
        default:
            print("default state")
            tableView.tableFooterView = loadingView
        }
    }
    
    func buildEmptyView() -> UIView {
        let frame = CGRect(x: 0, y: 0, width: resultView.tableView.frame.width, height: 100)
        let nib = UINib(nibName: "CustomFooterView", bundle: nil)
        
        let emptyView = nib.instantiate(withOwner: nil, options: nil).first as! CustomFooterView
        emptyView.frame = frame
        
        emptyView.messageLabel.text = "No results to show"
        
        return emptyView
    }
    
    func buildLoadingView() {
        let defaultFrame = CGRect(x: 0, y: 0, width: resultView.tableView.frame.width, height: 100)
        
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

//MARK: - UITableViewDataSource

extension ResultsSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewState.value.currentEntities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowViewCell", for: indexPath) as! TVShowViewCell
        cell.viewModel = viewModel.getModelFor(indexPath.row)
        
        if case .paging(_, let nextPage) = viewModel.viewState.value,
            indexPath.row == viewModel.viewState.value.currentEntities.count - 1 {
            print("Necesito otra page: \(nextPage)")
            viewModel.searchShows(for: nextPage)
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension ResultsSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedShow = viewModel.shows[indexPath.row]
        delegate?.resultsSearchViewController(self, didSelectedMovie: selectedShow.id)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
