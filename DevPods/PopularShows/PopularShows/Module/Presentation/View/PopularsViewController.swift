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

class PopularsViewController: UIViewController, StoryboardInstantiable, Loadable, Retryable, Emptiable {
  
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel: PopularViewModelProtocol!
  
  static func create(with viewModel: PopularViewModelProtocol) -> PopularsViewController {
    let controller = PopularsViewController.instantiateViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  let disposeBag = DisposeBag()
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupViewModel()
    viewModel.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = false
  }
  
  // MARK: - Setup UI
  
  func setupUI() {
    navigationItem.title = "Popular TV Shows"
    setupTable()
  }
  
  func setupTable() {
    tableView.registerNib(cellType: TVShowViewCell.self)
    
    tableView.tableFooterView = nil
    tableView.rowHeight = UITableView.automaticDimension
    
    tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  // MARK: - Setup ViewModel
  
  func setupViewModel() {
    let dataSource = configureTableViewDataSource()
    
    viewModel
      .viewState
      .map {  [SectionPopularView(header: "Popular Shows", items: $0.currentEntities)] }
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    viewModel
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
        strongSelf.viewModel.showIsPicked(with: item.entity.id)
    }
    .disposed(by: disposeBag)
  }
  
  fileprivate func handleTableState(with state: SimpleViewState<TVShowCellViewModel>) {
    
    switch state {
    case .loading:
      showLoadingView()
      hideMessageView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .none
      
    case .paging:
      hideLoadingView()
      hideMessageView()
      tableView.tableFooterView = LoadingView.defaultView
      tableView.separatorStyle = .singleLine
      
    case .populated:
      hideLoadingView()
      hideMessageView()
      tableView.tableFooterView = UIView()
      tableView.separatorStyle = .singleLine
      
    case .empty:
      hideLoadingView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .none
      showEmptyView(with: "No Populars TVShow to see")
      
    case .error(let message):
      hideLoadingView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .none
      showMessageView(with: message, errorHandler: { [weak self] in
        self?.viewModel.refreshView()
      })
    }
  }
  
  fileprivate func configureTableViewDataSource() ->
    RxTableViewSectionedReloadDataSource<SectionPopularView> {
      let configureCell = RxTableViewSectionedReloadDataSource<SectionPopularView>(
        configureCell: { [weak self] dataSource, tableView, indexPath, item in
          guard let strongSelf = self else { fatalError() }
          
          let cell = tableView.dequeueReusableCell(with: TVShowViewCell.self, for: indexPath)
          cell.viewModel = item
          
          if let totalItems = dataSource.sectionModels.first?.items.count, indexPath.row == totalItems - 1 {
            strongSelf.viewModel.didLoadNextPage()
          }
          return cell
      })
      return configureCell
  }
  
}

// MARK: - UITableViewDelegate

extension PopularsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 175.0
  }
}
