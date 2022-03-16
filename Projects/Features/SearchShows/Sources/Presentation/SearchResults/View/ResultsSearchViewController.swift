//
//  ResultsSearchViewController.swift
//  MyTvShows
//
//  Created by Jeans on 8/26/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Shared

class ResultsSearchViewController: NiblessViewController {

  private let disposeBag = DisposeBag()

  private var resultView: ResultListView = ResultListView()

  private var viewModel: ResultsSearchViewModelProtocol

  private var messageView = MessageView()

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

    resultView.tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
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
    handleSelection()
  }

  private func setupDataSource() {
    let dataSource = RxTableViewSectionedReloadDataSource<ResultSearchSectionModel>(
      configureCell: { [weak self] (_, tableView, indexPath, element) -> UITableViewCell in
      guard let strongSelf = self else {
        fatalError()
      }

      switch element {
      case .recentSearchs(items: let recentQuery):
        return strongSelf.makeCellForRecentSearch(tableView, at: indexPath, element: recentQuery)
      case .results(items: let showViewModel):
        return strongSelf.makeCellForResultSearch(tableView, at: indexPath, element: showViewModel)
      }
    })

    dataSource.titleForHeaderInSection = { dataSource, section in
      return dataSource.sectionModels[section].getHeader()
    }

    viewModel
      .dataSource
      .bind(to: resultView.tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }

  private  func handleSelection() {
    Observable
      .zip(resultView.tableView.rx.itemSelected,
           resultView.tableView.rx.modelSelected(ResultSearchSectionItem.self))
      .subscribe(onNext: { [weak self] (index, element) in
        guard let strongSelf = self else {
          return
        }

        switch element {
        case .recentSearchs(let query) :
          strongSelf.resultView.tableView.deselectRow(at: index, animated: true)
          strongSelf.viewModel.recentSearchIsPicked(query: query)

        case .results(let viewModel):
          strongSelf.resultView.tableView.deselectRow(at: index, animated: true)
          strongSelf.viewModel.showIsPicked(idShow: viewModel.entity.id)
        }
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
