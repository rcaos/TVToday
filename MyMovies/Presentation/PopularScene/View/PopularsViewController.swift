//
//  PupularShowsViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PopularsViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel:PopularViewModel!
  private var popularViewControllersFactory: PopularViewControllersFactory!
  
  static func create(with viewModel: PopularViewModel,
                     popularViewControllersFactory: PopularViewControllersFactory) -> PopularsViewController {
    let controller = PopularsViewController.instantiateViewController()
    controller.viewModel = viewModel
    controller.popularViewControllersFactory = popularViewControllersFactory
    return controller
  }
  
  lazy var loadingView = LoadingView(frame: .zero)
  lazy var emptyView = MessageView(message: "No TVShow to show")
  
  let disposeBag = DisposeBag()
  
  //MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupViewModel()
    viewModel.getShows(for: 1)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = false
  }
  
  //MARK: - Setup UI
  
  func setupUI() {
    navigationItem.title = "Popular TV Shows"
    setupTable()
    setupViews()
  }
  
  func setupViews() {
    loadingView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
    emptyView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
  }
  
  func setupTable() {
    let nibName = UINib(nibName: "TVShowViewCell", bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: "TVShowViewCell")
    
    tableView.tableFooterView = loadingView
    tableView.rowHeight = UITableView.automaticDimension
  }
  
  // MARK: - Setup ViewModel
  
  func setupViewModel() {
    viewModel.output
      .viewState
      .map { $0.currentEntities }
      .bind(to: tableView.rx.items(cellIdentifier: "TVShowViewCell", cellType: TVShowViewCell.self)) {
        [weak self] (index, element, cell) in
        guard let strongSelf = self else { return }
        
        cell.viewModel = self?.viewModel.getModelFor(element)
        
        if case .paging(let entities, let nextPage) = try? strongSelf.viewModel.viewStateObservableSubject.value(),
          index == entities.count - 1  {
          strongSelf.viewModel.getShows(for: nextPage)
        }
    }
    .disposed(by: disposeBag)
    
    viewModel.output
      .viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.handleTableState(with: state)
      })
      .disposed(by: disposeBag)
    
    Observable
      .zip( tableView.rx.itemSelected, tableView.rx.modelSelected(TVShow.self) )
      .bind { [weak self] (indexPath, item) in
        guard let strongSelf = self else { return }
        strongSelf.tableView.deselectRow(at: indexPath, animated: true)
        strongSelf.handle(item.id)
    }
    .disposed(by: disposeBag)
  }
  
  fileprivate func handleTableState(with state: SimpleViewState<TVShow>) {
    switch state {
    case .loading, .paging :
      tableView.tableFooterView = loadingView
    case .empty:
      tableView.tableFooterView = emptyView
    case .error(let message):
      emptyView.messageLabel.text = message
      tableView.tableFooterView = emptyView
    default:
      tableView.tableFooterView = nil
    }
  }
}

// MARK: - TODO, refactor navigation

extension PopularsViewController {
  
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

