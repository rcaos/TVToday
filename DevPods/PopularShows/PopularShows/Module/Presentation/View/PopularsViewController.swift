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
import Shared

class PopularsViewController: UIViewController, StoryboardInstantiable, Loadable {
  
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel: PopularViewModel!
  
  static func create(with viewModel: PopularViewModel) -> PopularsViewController {
    let controller = PopularsViewController.instantiateViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  lazy var loadingView = LoadingView(frame: .zero)
  lazy var messageView = MessageView(message: "")
  
  let disposeBag = DisposeBag()
  
  // MARK: - Life Cycle
  
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
  
  // MARK: - Setup UI
  
  func setupUI() {
    navigationItem.title = "Popular TV Shows"
    setupTable()
    setupViews()
  }
  
  func setupViews() {
    loadingView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
    messageView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
  }
  
  func setupTable() {
    tableView.registerNib(cellType: TVShowViewCell.self)
    
    tableView.tableFooterView = loadingView
    tableView.rowHeight = UITableView.automaticDimension
    
    tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  // MARK: - Setup ViewModel
  
  func setupViewModel() {
    viewModel.output
      .viewState
      .map { $0.currentEntities }
      .bind(to:
        tableView.rx.items( cellIdentifier: "TVShowViewCell",
                            cellType: TVShowViewCell.self)) { [weak self] (index, element, cell) in
                              guard let strongSelf = self else { return }
                              
                              cell.viewModel = element
                              
                              if case .paging(let entities, let nextPage) = try? strongSelf.viewModel.viewStateObservableSubject.value(),
                                index == entities.count - 1 {
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
      .zip( tableView.rx.itemSelected, tableView.rx.modelSelected(TVShowCellViewModel.self) )
      .bind { [weak self] (indexPath, item) in
        guard let strongSelf = self else { return }
        strongSelf.tableView.deselectRow(at: indexPath, animated: true)
        strongSelf.viewModel.navigateTo(step: PopularStep.showIsPicked(withId: item.entity.id) )
    }
    .disposed(by: disposeBag)
  }
  
  fileprivate func handleTableState(with state: SimpleViewState<TVShowCellViewModel>) {
    hideLoadingView()
    
    switch state {
    case .loading:
      showLoadingView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .none
      
    case .paging:
      tableView.tableFooterView = loadingView
      tableView.separatorStyle = .singleLine
      
    case .populated:
      tableView.tableFooterView = nil
      tableView.separatorStyle = .singleLine
      
    case .empty:
      messageView.messageLabel.text = "No TVShow to show"
      tableView.tableFooterView = messageView
      tableView.separatorStyle = .none
      
    case .error(let error):
      messageView.messageLabel.text = error
      tableView.tableFooterView = messageView
      tableView.separatorStyle = .none
    }
  }
}

// MARK: - UITableViewDelegate

extension PopularsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 175.0
  }
}
