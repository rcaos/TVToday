//
//  SearchOptionRootView.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 8/21/20.
//

import UIKit
import Shared
import RxSwift
import RxDataSources

class SearchOptionRootView: NiblessView {

  private let viewModel: SearchOptionsViewModelProtocol

  private let disposeBag = DisposeBag()

  let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.registerNib(cellType: TVShowViewCell.self, bundle: SharedResources.bundle)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.tableFooterView = UIView()
    tableView.contentInsetAdjustmentBehavior = .automatic
    return tableView
  }()

  init(frame: CGRect = .zero, viewModel: SearchOptionsViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)

    addSubview(tableView)
    setupUI()
  }

  fileprivate func setupUI() {
    registerCells()
    setupDataSource()
    handleSelection()
  }

  fileprivate func registerCells() {
    tableView.registerCell(cellType: VisitedShowTableViewCell.self)
    tableView.registerCell(cellType: GenreTableViewCell.self)
  }

  fileprivate func setupDataSource() {
    let dataSource = RxTableViewSectionedReloadDataSource<SearchOptionsSectionModel>(
      configureCell: { [weak self] (_, _, indexPath, element) -> UITableViewCell in
        guard let strongSelf = self else { fatalError() }
        switch element {
        case .showsVisited(items: let viewModel):
          return strongSelf.makeCellForShowVisited(at: indexPath, cellViewModel: viewModel)
        case .genres(items: let genre):
          return strongSelf.makeCellForGenre(at: indexPath, viewModel: genre)
        }
    })

    dataSource.titleForHeaderInSection = { dataSource, section in
      return dataSource.sectionModels[section].getHeader()
    }

    viewModel
      .dataSource
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }

  fileprivate func handleSelection() {
    Observable
      .zip( tableView.rx.itemSelected, tableView.rx.modelSelected(SearchOptionsSectionModel.Item.self) )
      .bind { [weak self] (indexPath, item) in
        guard let strongSelf = self else { return }
        strongSelf.tableView.deselectRow(at: indexPath, animated: true)
        strongSelf.viewModel.modelIsPicked(with: item)
    }
    .disposed(by: disposeBag)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    tableView.frame = bounds
  }
}

// MARK: - Build Cells
extension SearchOptionRootView {

  private func makeCellForShowVisited(at indexPath: IndexPath, cellViewModel: VisitedShowViewModelProtocol) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: VisitedShowTableViewCell.self, for: indexPath)
    cell.setupCell(with: cellViewModel)
    return cell
  }

  private func makeCellForGenre(at indexPath: IndexPath, viewModel: GenreViewModelProtocol) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: GenreTableViewCell.self, for: indexPath)
    cell.setViewModel(viewModel)
    return cell
  }
}
