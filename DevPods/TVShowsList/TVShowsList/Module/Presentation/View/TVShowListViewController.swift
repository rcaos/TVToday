//
//  TVShowListViewController.swift
//  MyTvShows
//
//  Created by Jeans on 8/26/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Shared

class TVShowListViewController: UIViewController, StoryboardInstantiable, Loadable, Retryable, Emptiable {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var viewModel: TVShowListViewModelProtocol!
  
  private let disposeBag = DisposeBag()
  
  static func create(with viewModel: TVShowListViewModelProtocol) -> TVShowListViewController {
    let controller = TVShowListViewController.instantiateViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTable()
    setupViewModel()
    viewModel.viewDidLoad()
  }
  
  deinit {
    viewModel.viewDidFinish()
    print("deinit \(Self.self)")
  }
  
  // MARK: - SetupTable
  
  func setupTable() {
    tableView.registerNib(cellType: TVShowViewCell.self)
    
    tableView.refreshControl = DefaultRefreshControl(refreshHandler: { [weak self] in
      self?.viewModel.refreshView()
    })
    
    tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  // MARK: - SetupViewModel
  
  private func setupViewModel() {
    subscribeToViewState()
    subscribeToData()
    handleSelectionItems()
  }
  
  private func subscribeToViewState() {
    viewModel
      .viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.configView(with: state)
      })
      .disposed(by: disposeBag)
  }
  
  private func subscribeToData() {
    let dataSource = configureTableViewDataSource()
    
    viewModel
      .viewState
      .map {  [SectionTVShowListView(header: "TV Shows List", items: $0.currentEntities)] }
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
  
  private func handleSelectionItems() {
    Observable
      .zip( tableView.rx.itemSelected, tableView.rx.modelSelected(TVShowCellViewModel.self) )
      .bind { [weak self] (indexPath, item) in
        guard let strongSelf = self else { return }
        strongSelf.tableView.deselectRow(at: indexPath, animated: true)
        strongSelf.viewModel.showIsPicked(with: item.entity.id)
    }
    .disposed(by: disposeBag)
  }
  
  private func configView(with state: SimpleViewState<TVShowCellViewModel>) {
    
    tableView.refreshControl?.endRefreshing(with: 0.5)
    
    switch state {
    case .loading:
      showLoadingView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .none
      hideMessageView()
      
    case .paging :
      hideLoadingView()
      tableView.tableFooterView = LoadingView.defaultView
      tableView.separatorStyle = .singleLine
      hideMessageView()
      
    case .populated :
      hideLoadingView()
      tableView.tableFooterView = UIView()
      tableView.separatorStyle = .singleLine
      hideMessageView()
      
    case .empty:
      hideLoadingView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .none
      showEmptyView(with: "No TvShow to see")
      
    case .error(let message):
      hideLoadingView()
      tableView.tableFooterView = UIView()
      tableView.separatorStyle = .none
      showMessageView(with: message,
                      errorHandler: { [weak self] in
                        self?.viewModel.refreshView()
      })
    }
  }
  
  fileprivate func configureTableViewDataSource() ->
    RxTableViewSectionedReloadDataSource<SectionTVShowListView> {
      let configureCell = RxTableViewSectionedReloadDataSource<SectionTVShowListView>(
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

extension TVShowListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 175.0
  }
}
