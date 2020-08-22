//
//  TVShowListRootView.swift
//  TVShowsList
//
//  Created by Jeans Ruiz on 8/21/20.
//

import Shared
import RxSwift
import RxDataSources

class TVShowListRootView: NiblessView {
  
  private let viewModel: TVShowListViewModelProtocol
  
  let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.registerNib(cellType: TVShowViewCell.self)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.tableFooterView = UIView()
    tableView.contentInsetAdjustmentBehavior = .automatic
    return tableView
  }()
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializer
  
  init(frame: CGRect = .zero, viewModel: TVShowListViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)
    
    addSubview(tableView)
    setupUI()
  }
  
  func stopRefresh() {
    tableView.refreshControl?.endRefreshing(with: 0.5)
  }
  
  fileprivate func setupUI() {
    setupTableView()
    setupDataSource()
    handleSelectionItems()
  }
  
  // MARK: - Setup TableView
  
  fileprivate func setupTableView() {
    tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    tableView.refreshControl = DefaultRefreshControl(refreshHandler: { [weak self] in
      self?.viewModel.refreshView()
    })
  }
  
  private func setupDataSource() {
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
  
  override func layoutSubviews() {
    super.layoutSubviews()
    tableView.frame = bounds
  }
}

// MARK: - UITableViewDelegate

extension TVShowListRootView: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 175.0
  }
}
