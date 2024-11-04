//
//  Created by Jeans Ruiz on 8/21/20.
//

import UIKit
import Combine
import UI

class SearchOptionRootView: NiblessView {

  private let viewModel: SearchOptionsViewModelProtocol

  let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.tableFooterView = UIView()
    tableView.contentInsetAdjustmentBehavior = .automatic
    tableView.sectionHeaderHeight = UITableView.automaticDimension
    tableView.estimatedSectionHeaderHeight = 30
    return tableView
  }()

  typealias DataSource = UITableViewDiffableDataSource<SearchOptionsSectionView, SearchSectionItem>
  typealias Snapshot = NSDiffableDataSourceSnapshot<SearchOptionsSectionView, SearchSectionItem>
  private var dataSource: DataSource?

  private var disposeBag = Set<AnyCancellable>()

  init(frame: CGRect = .zero, viewModel: SearchOptionsViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)

    addSubview(tableView)
    setupUI()
  }

  private func setupUI() {
    registerCells()
    setupDataSource()
    subscribe()
  }

  private func registerCells() {
    tableView.registerCell(cellType: VisitedShowTableViewCell.self)
    tableView.registerCell(cellType: GenreTableViewCell.self)
  }

  private func setupDataSource() {
    tableView.delegate = self

    dataSource = SearchSectionTableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, model in
      guard let strongSelf = self else { fatalError() }
      switch model {
      case .showsVisited(items: let viewModel):
        return strongSelf.makeCellForShowVisited(tableView, at: indexPath, cellViewModel: viewModel)
      case .genres(items: let genre):
        return strongSelf.makeCellForGenre(tableView, at: indexPath, viewModel: genre)
      }
    })
  }

  private func subscribe() {
    viewModel.dataSource
      .map { dataSource -> Snapshot in
        var snapShot = Snapshot()
        for element in dataSource {
          snapShot.appendSections([element.sectionView])
          snapShot.appendItems(element.items, toSection: element.sectionView)
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

  private func makeCellForShowVisited(_ tableView: UITableView, at indexPath: IndexPath,
                                      cellViewModel: VisitedShowViewModelProtocol) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: VisitedShowTableViewCell.self, for: indexPath)
    cell.setupCell(with: cellViewModel)
    return cell
  }

  private func makeCellForGenre(_ tableView: UITableView, at indexPath: IndexPath, viewModel: GenreViewModelProtocol) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: GenreTableViewCell.self, for: indexPath)
    cell.setViewModel(viewModel)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension SearchOptionRootView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let model = dataSource?.itemIdentifier(for: indexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      viewModel.modelIsPicked(with: model)
    }
  }
}
