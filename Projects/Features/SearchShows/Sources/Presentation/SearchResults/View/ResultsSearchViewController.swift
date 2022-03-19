//
//  ResultsSearchViewController.swift
//  MyTvShows
//
//  Created by Jeans on 8/26/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import Shared

class ResultsSearchViewController: NiblessViewController {

  private let disposeBag = DisposeBag()

  private let resultView: ResultListView = ResultListView()

  private let viewModel: ResultsSearchViewModelProtocol

  private let messageView = MessageView()

  typealias DataSource = UITableViewDiffableDataSource<ResultSearchSectionView, ResultSearchSectionItem>
  typealias Snapshot = NSDiffableDataSourceSnapshot<ResultSearchSectionView, ResultSearchSectionItem>
  private var dataSource: DataSource?

  // MARK: - Life Cycle
  init(viewModel: ResultsSearchViewModelProtocol) {
    self.viewModel = viewModel
    super.init()
  }

  override func loadView() {
    super.loadView()
    view = resultView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
    setupTableView()
    setupViewModel()
    setupTable()
  }

  private func setupViews() {
    messageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
  }

  private func setupTableView() {
    resultView.tableView.registerCell(cellType: TVShowViewCell.self)
    resultView.tableView.registerCell(cellType: RecentSearchTableViewCell.self)
    resultView.tableView.delegate = self
  }

  // MARK: - SetupViewModel
  private func setupViewModel() {
    viewModel
      .viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.configView(with: state)
      })
      .disposed(by: disposeBag)
  }

  // MARK: - Setup Table View
  private func setupTable() {
    setupDataSource()
    subscribe()
  }

  private func setupDataSource() {
    dataSource = CustomSectionTableViewDiffableDataSource(tableView: resultView.tableView, cellProvider: { [weak self] tableView, indexPath, model in
      guard let strongSelf = self else {
        fatalError()
      }

      switch model {
      case let .recentSearchs(model):
        return strongSelf.makeCellForRecentSearch(tableView, at: indexPath, element: model)
      case let .results(viewModel):
        return strongSelf.makeCellForResultSearch(tableView, at: indexPath, element: viewModel)
      }
    })

  }

  private func subscribe() {
    viewModel
      .dataSource
      .map { dataSource -> Snapshot in
        var snapShot = Snapshot()
        for element in dataSource {
          snapShot.appendSections([element.section])
          snapShot.appendItems(element.items, toSection: element.section)
        }
        return snapShot
      }
      .subscribe(onNext: { [weak self] snapshot in
        self?.dataSource?.apply(snapshot)
      })
      .disposed(by: disposeBag)
  }

  // MARK: - Handle View State
  private func configView(with state: ResultViewState) {
    let tableView = resultView.tableView

    switch state {
    case .initial :
      tableView.tableFooterView = UIView()
      tableView.separatorStyle = .singleLine

    case .loading:
      tableView.tableFooterView = LoadingView.defaultView
      tableView.separatorStyle = .none

    case .populated :
      tableView.tableFooterView = UIView()
      tableView.separatorStyle = .singleLine

    case .empty :
      messageView.messageLabel.text = "No results to Show"
      tableView.tableFooterView = messageView
      tableView.separatorStyle = .none

    case .error(let message):
      messageView.messageLabel.text = message
      tableView.tableFooterView = messageView
      tableView.separatorStyle = .none
    }
  }
}

// MARK: - UITableViewDelegate
extension ResultsSearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let viewState = viewModel.getViewState()

    switch viewState {
    case .initial:
      return UITableView.automaticDimension
    case .populated:
      return 175.0
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let model = dataSource?.itemIdentifier(for: indexPath) {
      tableView.deselectRow(at: indexPath, animated: true)

      switch model {
      case .recentSearchs(let query) :
        viewModel.recentSearchIsPicked(query: query)

      case .results(let itemViewModel):
        viewModel.showIsPicked(idShow: itemViewModel.entity.id)
      }
    }
  }
}

// MARK: - Build Cells
extension ResultsSearchViewController {
  private func makeCellForRecentSearch(_ tableView: UITableView, at indexPath: IndexPath, element: String) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: RecentSearchTableViewCell.self, for: indexPath)
    cell.setModel(with: element)
    return cell
  }

  private func makeCellForResultSearch(_ tableView: UITableView, at indexPath: IndexPath, element: TVShowCellViewModel) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: TVShowViewCell.self, for: indexPath)
    cell.setModel(viewModel: element)
    return cell
  }
}
