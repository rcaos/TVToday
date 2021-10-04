//
//  EpisodesListRootView.swift
//  ShowDetails
//
//  Created by Jeans Ruiz on 8/21/20.
//

import UIKit
import RxSwift
import RxDataSources
import Shared

class EpisodesListRootView: NiblessView {

  private var viewModel: EpisodesListViewModelProtocol

  let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.registerCell(cellType: HeaderSeasonsTableViewCell.self)
    tableView.registerCell(cellType: SeasonListTableViewCell.self)
    tableView.registerNib(cellType: EpisodeItemTableViewCell.self, bundle: Bundle.module)

    tableView.rowHeight = UITableView.automaticDimension
    tableView.tableFooterView = UIView()
    tableView.contentInsetAdjustmentBehavior = .automatic
    return tableView
  }()

  private let disposeBag = DisposeBag()

  init(frame: CGRect = .zero, viewModel: EpisodesListViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)
    addSubview(tableView)
    setupView()
  }

  fileprivate func setupView() {
    setupTable()
    setupDataSource()
  }

  fileprivate func setupTable() {
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }

  fileprivate func setupDataSource() {
    let dataSource = RxTableViewSectionedAnimatedDataSource<SeasonsSectionModel>(
      configureCell: { [weak self] (_, _, indexPath, element) -> UITableViewCell in
        guard let strongSelf = self else { fatalError() }
        switch element {
        case .headerShow(viewModel: let viewModel):
          return strongSelf.makeCellForHeaderShow(at: indexPath, viewModel: viewModel)
        case .seasons(number: let numberOfSeasons):
          return strongSelf.makeCellForSeasonNumber(at: indexPath, element: numberOfSeasons)
        case .episodes(items: let episode):
          return strongSelf.makeCellForEpisode(at: indexPath, element: episode)
        }
    })

    viewModel
      .data
      .bind(to: tableView.rx.items(dataSource: dataSource) )
      .disposed(by: disposeBag)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    tableView.frame = bounds
  }
}

// MARK: - Configure Cells
extension EpisodesListRootView {
  private func makeCellForHeaderShow(at indexPath: IndexPath, viewModel: SeasonHeaderViewModelProtocol) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: HeaderSeasonsTableViewCell.self, for: indexPath)
    if cell.viewModel == nil {
      cell.setModel(viewModel: viewModel)
    }
    return cell
  }

  private func makeCellForSeasonNumber(at indexPath: IndexPath, element: Int) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: SeasonListTableViewCell.self, for: indexPath)
    if cell.viewModel == nil {
      cell.setViewModel(viewModel: viewModel.buildModelForSeasons(with: element))
    }
    return cell
  }

  private func makeCellForEpisode(at indexPath: IndexPath, element: EpisodeSectionModelType) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: EpisodeItemTableViewCell.self, for: indexPath)
    if let model = viewModel.getModel(for: element) {
      cell.viewModel = model
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
