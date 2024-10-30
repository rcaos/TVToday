//
//  Created by Jeans Ruiz on 8/21/20.
//

import UIKit
import Combine
import UI

class PopularsRootView: NiblessView {

  private let viewModel: PopularViewModelProtocol

  let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.registerCell(cellType: TVShowViewCell.self)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UITableView.automaticDimension
    tableView.contentInsetAdjustmentBehavior = .automatic
    return tableView
  }()

  typealias DataSource = UITableViewDiffableDataSource<SectionPopularView, TVShowCellViewModel>
  typealias Snapshot = NSDiffableDataSourceSnapshot<SectionPopularView, TVShowCellViewModel>
  private var dataSource: DataSource?

  private var disposeBag = Set<AnyCancellable>()

  // MARK: - Initializer
  init(frame: CGRect = .zero, viewModel: PopularViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)
    setupUI()
  }

  private func setupUI() {
    setupHierarchy()
    setupTableView()
    setupDataSource()
    subscribe()
  }

  private func setupHierarchy() {
    addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.pin(to: self)
  }

  // MARK: - Setup TableView
  private func setupTableView() {
    tableView.registerCell(cellType: TVShowViewCell.self)
    tableView.delegate = self
    tableView.refreshControl = DefaultRefreshControl(refreshHandler: { [weak self] in
      Task {
        await self?.viewModel.refreshView()
      }
    })
  }

  private func setupDataSource() {
    dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model in
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
      .receive(on: defaultScheduler)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] snapshot in
        self?.dataSource?.apply(snapshot)
      })
      .store(in: &disposeBag)
  }

  func stopRefresh() {
    tableView.refreshControl?.endRefreshing(with: 0.5)
  }
}

// MARK: - UITableViewDelegate
extension PopularsRootView: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    viewModel.showIsPicked(index: indexPath.row)
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let totalItems = dataSource?.snapshot().itemIdentifiers(inSection: .list).count ?? 0
    Task {
      await viewModel.willDisplayRow(indexPath.row, outOf: totalItems)
    }
  }
}
