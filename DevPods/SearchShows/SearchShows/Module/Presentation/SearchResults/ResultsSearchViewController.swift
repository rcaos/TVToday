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

class ResultsSearchViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  
  private var resultView: ResultListView = ResultListView()
  
  private var viewModel: ResultsSearchViewModel
  
  private var emptyView = MessageView(message: "No results to Show")
  private var loadingView = LoadingView(frame: .zero)
  
  // MARK: - Life Cycle
  
  init(viewModel: ResultsSearchViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  override func loadView() {
    super.loadView()
    view = resultView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    registerCells()
    setupViewModel()
    setupTable()
  }
  
  private func setupViews() {
    emptyView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
    loadingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
  }
  
  private func registerCells() {
    resultView.tableView.registerNib(cellType: TVShowViewCell.self)
    resultView.tableView.registerNib(cellType: RecentSearchTableViewCell.self)
  }
  
  // MARK: - SetupViewModel
  
  private func setupViewModel() {
    
    viewModel.output
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
    let dataSource = RxTableViewSectionedReloadDataSource<ResultSearchSectionModel>(configureCell: { [weak self] (_, tableView, indexPath, element) -> UITableViewCell in
      guard let strongSelf = self else { fatalError() }
      
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
    
    viewModel.output
      .dataSource
      .bind(to: resultView.tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
  
  private  func handleSelection() {
    Observable
      .zip(resultView.tableView.rx.itemSelected,
           resultView.tableView.rx.modelSelected(ResultSearchSectionItem.self))
      .subscribe(onNext: { [weak self] (index, element) in
        guard let strongSelf = self else { return }
        
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
  
  private func configView(with state: ResultsSearchViewModel.ViewState) {
    let tableView = resultView.tableView
    
    switch state {
    case .initial :
      tableView.tableFooterView = nil
      tableView.separatorStyle = .singleLine
    case .populated :
      tableView.tableHeaderView = nil
      tableView.tableFooterView = nil
      tableView.separatorStyle = .singleLine
    case .empty :
      tableView.tableFooterView = emptyView
      tableView.separatorStyle = .none
    default:
      tableView.tableFooterView = loadingView
    }
  }
}

// MARK: - Build Cells

extension ResultsSearchViewController {
  
  private func makeCellForRecentSearch(_ tableView: UITableView, at indexPath: IndexPath, element: String) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: RecentSearchTableViewCell.self, for: indexPath)
    cell.title = element
    return cell
  }
  
  private func makeCellForResultSearch(_ tableView: UITableView, at indexPath: IndexPath, element: TVShowCellViewModel) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: TVShowViewCell.self, for: indexPath)
    cell.viewModel = element
    return cell
  }
}
