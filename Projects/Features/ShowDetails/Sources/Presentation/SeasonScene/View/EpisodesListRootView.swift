//
//  EpisodesListRootView.swift
//  ShowDetails
//
//  Created by Jeans Ruiz on 8/21/20.
//

import UIKit
import Combine
import Shared

class EpisodesListRootView: NiblessView {

  private let viewModel: EpisodesListViewModelProtocol

  let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.registerCell(cellType: HeaderSeasonsTableViewCell.self)
    tableView.registerCell(cellType: SeasonListTableViewCell.self)
    tableView.registerCell(cellType: EpisodeItemTableViewCell.self)

    tableView.rowHeight = UITableView.automaticDimension
    tableView.tableFooterView = UIView()
    tableView.contentInsetAdjustmentBehavior = .automatic
    return tableView
  }()

  typealias DataSource = UITableViewDiffableDataSource<SeasonsSectionCollection, SeasonsSectionItem>
  typealias Snapshot = NSDiffableDataSourceSnapshot<SeasonsSectionCollection, SeasonsSectionItem>
  private var dataSource: DataSource?

  private var disposeBag = Set<AnyCancellable>()

  init(frame: CGRect = .zero, viewModel: EpisodesListViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)
    addSubview(tableView)
    setupView()
  }

  private func setupView() {
    setupTable()
    setupDataSource()
    subscribe()
  }

  private func setupTable() {
    tableView.delegate = self
  }

  private func setupDataSource() {
    dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self] _, indexPath, section in
      guard let strongSelf = self else {
        fatalError()
      }
      switch section {
      case .headerShow(viewModel: let viewModel):
        return strongSelf.makeCellForHeaderShow(at: indexPath, viewModel: viewModel)
      case .seasons:
        return strongSelf.makeCellForSeasonNumber(at: indexPath)
      case .episodes(items: let episode):
        return strongSelf.makeCellForEpisode(at: indexPath, element: episode)
      }
    })
  }

  private func subscribe() {
    viewModel
      .data
      .map { data -> Snapshot in
        var snapShot = Snapshot()
        for section in data {
          snapShot.appendSections([section.sectionCollection])
          snapShot.appendItems(section.items, toSection: section.sectionCollection)
        }
        return snapShot
      }
      .receive(on: RunLoop.main)
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

// MARK: - Configure Cells
extension EpisodesListRootView {
  private func makeCellForHeaderShow(at indexPath: IndexPath, viewModel: SeasonHeaderViewModel) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: HeaderSeasonsTableViewCell.self, for: indexPath)
    if cell.viewModel == nil {
      cell.setModel(viewModel: viewModel)
    }
    return cell
  }

  private func makeCellForSeasonNumber(at indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: SeasonListTableViewCell.self, for: indexPath)
    if cell.viewModel == nil {
      cell.setViewModel(viewModel: viewModel.getViewModelForAllSeasons() )
    }
    return cell
  }

  private func makeCellForEpisode(at indexPath: IndexPath, element: EpisodeSectionModelType) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: EpisodeItemTableViewCell.self, for: indexPath)
    if let model = viewModel.getModel(for: element) {
      cell.setModel(viewModel: model)
    }
    return cell
  }
}

// MARK: - UITableViewDelegate
extension EpisodesListRootView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    switch indexPath.section {
    case 0:
      return UITableView.automaticDimension
    case 1:
      return 65.0
    default:
      return 110.0
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
