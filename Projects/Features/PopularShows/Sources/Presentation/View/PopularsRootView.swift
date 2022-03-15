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

  typealias DataSource = UITableViewDiffableDataSource<SectionPopularView, TVShowCellViewModel>
  typealias Snapshot = NSDiffableDataSourceSnapshot<SectionPopularView, TVShowCellViewModel>

  private var dataSource: DataSource?
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
    subscribe()
  }

  // MARK: - Setup TableView
  fileprivate func setupTableView() {
    tableView.delegate = self
    tableView.refreshControl = DefaultRefreshControl(refreshHandler: { [weak self] in
      self?.viewModel.refreshView()
    })
  }

  fileprivate func setupDataSource() {
    tableView.registerCell(cellType: TVShowViewCell.self)

    dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, model in
      let cell = tableView.dequeueReusableCell(with: TVShowViewCell.self, for: indexPath)
      cell.setModel(viewModel: model)

      // MARK: - TODO, use willDisplay instead
      if let totalItems = self?.dataSource?.snapshot().itemIdentifiers(inSection: .list).count, indexPath.row == totalItems - 1 {
        self?.viewModel.didLoadNextPage()
      }
      return cell
    })
  }

  private func subscribe() {
    viewModel
      .viewState
      .map { viewState -> Snapshot in
        var snapShot = Snapshot()
        snapShot.appendSections([.list])
        snapShot.appendItems(viewState.currentEntities, toSection: .list)
        return snapShot
      }
      .subscribe(onNext: { [weak self] snapshot in
        self?.dataSource?.apply(snapshot)
      })
      .disposed(by: disposeBag)
  }

  fileprivate func handleSelectionItems() {
//    Observable
//      .zip( tableView.rx.itemSelected, tableView.rx.modelSelected(TVShowCellViewModel.self) )
//      .bind { [weak self] (indexPath, item) in
//        guard let strongSelf = self else { return }
//        strongSelf.tableView.deselectRow(at: indexPath, animated: true)
//        strongSelf.viewModel.showIsPicked(with: item.entity.id)
//    }
//    .disposed(by: disposeBag)
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
