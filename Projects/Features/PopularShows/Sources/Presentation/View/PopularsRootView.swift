//
//  PopularsRootView.swift
//  PopularShows
//
//  Created by Jeans Ruiz on 8/21/20.
//

import UIKit
import CoreGraphics
import Shared
import RxSwift
import RxDataSources

class PopularsRootView: NiblessView {

  private let viewModel: PopularViewModelProtocol

  let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.registerCell(cellType: TVShowViewCell.self)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.tableFooterView = UIView()
    tableView.contentInsetAdjustmentBehavior = .automatic
    return tableView
  }()

  private let disposeBag = DisposeBag()

  // MARK: - Initializer
  init(frame: CGRect = .zero, viewModel: PopularViewModelProtocol) {
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

  fileprivate func setupDataSource() {
    let dataSource = configureTableViewDataSource()
    viewModel
      .viewState
      .map {  [SectionPopularView(header: "Popular Shows", items: $0.currentEntities)] }
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }

  fileprivate func handleSelectionItems() {
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
    RxTableViewSectionedReloadDataSource<SectionPopularView> {
      let configureCell = RxTableViewSectionedReloadDataSource<SectionPopularView>(
        configureCell: { [weak self] dataSource, tableView, indexPath, item in
          guard let strongSelf = self else {
            fatalError()
          }

          let cell = tableView.dequeueReusableCell(with: TVShowViewCell.self, for: indexPath)
          cell.setModel(viewModel: item)

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
extension PopularsRootView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 175.0
  }
}
