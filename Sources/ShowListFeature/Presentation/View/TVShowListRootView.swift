//
//  TVShowListRootView.swift
//  TVShowsList
//
//  Created by Jeans Ruiz on 8/21/20.
//

import UIKit
import Combine
import UI

class TVShowListRootView: NiblessView {

  private let viewModel: TVShowListViewModelProtocol

  let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.registerCell(cellType: TVShowViewCell.self)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UITableView.automaticDimension
    tableView.tableFooterView = UIView()
    tableView.contentInsetAdjustmentBehavior = .automatic
    return tableView
  }()

  typealias DataSource = UITableViewDiffableDataSource<SectionListShowsView, TVShowCellViewModel>
  typealias Snapshot = NSDiffableDataSourceSnapshot<SectionListShowsView, TVShowCellViewModel>
  private var dataSource: DataSource?

  private var disposeBag = Set<AnyCancellable>()

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

  private func setupUI() {
    setupTableView()
    setupDataSource()
    subscribe()
  }

  private func setupTableView() {
    tableView.registerCell(cellType: TVShowViewCell.self)
    tableView.delegate = self
    tableView.refreshControl = DefaultRefreshControl(refreshHandler: { [weak self] in
      self?.viewModel.refreshView()
    })
  }

  private func setupDataSource() {
    dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, model in
      let cell = tableView.dequeueReusableCell(with: TVShowViewCell.self, for: indexPath)
      cell.setModel(viewModel: model)
      return cell
    })
  }

  private func subscribe() {
    viewModel
      .viewStateObservableSubject
      .map { viewState -> Snapshot in
        var snapShot = Snapshot()
        snapShot.appendSections([.list])
        snapShot.appendItems(viewState.currentEntities, toSection: .list)
        return snapShot
      }
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] snapshot in
        self?.dataSource?.apply(snapshot)
      })
      .store(in: &disposeBag)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    tableView.frame = bounds
  }
}

// MARK: - UITableViewDelegate
extension TVShowListRootView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    viewModel.showIsPicked(index: indexPath.row)
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let totalItems = dataSource?.snapshot().itemIdentifiers(inSection: .list).count ?? 0
    viewModel.willDisplayRow(indexPath.row, outOf: totalItems)
  }
}
