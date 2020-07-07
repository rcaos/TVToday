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

protocol ResultsSearchViewControllerDelegate: class {
  func resultsSearchViewController(_ resultsSearchViewController: ResultsSearchViewController, didSelectedMovie movie: Int )
}

class ResultsSearchViewController: UIViewController {
  
  let disposeBag = DisposeBag()
  
  var resultView: ResultListView = ResultListView()
  
  weak var delegate: ResultsSearchViewControllerDelegate?
  
  var viewModel: ResultsSearchViewModel
  
  var emptyView = MessageView(message: "No results to Show")
  var loadingView = LoadingView(frame: .zero)
  
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
    print("loadView???")
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    setupTable()
    setupViewModel()
    print("viewDidLoad???")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("viewDidAppear")
  }
  
  func setupViews() {
    emptyView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
    loadingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
  }
  
  func setupTable() {
    resultView.tableView.registerNib(cellType: TVShowViewCell.self)
    resultView.tableView.registerNib(cellType: RecentSearchTableViewCell.self)
  }
  
  // MARK: - SetupViewModel
  
  func setupDataSource() {
    let dataSource = RxTableViewSectionedReloadDataSource<ResultSearchSectionModel>(configureCell: { [weak self] (_, tableView, indexPath, element) -> UITableViewCell in
      guard let strongSelf = self else { fatalError() }
      
      // MARK: - TODO, call "showsObservableSubject" dont be stay here
      //      if case .paging(let entities, let nextPage) = try? strongSelf.viewModel.viewStateObservableSubject.value(),
      //      indexPath.row == entities.count - 1 {
      //        strongSelf.viewModel.searchShows(for: nextPage)
      //      }
      switch element {
      case .recentSearchs(items: let recentQuery):
        return strongSelf.makeCellForRecentSearch(tableView, at: indexPath, element: recentQuery)
      case .results(items: let showViewModel):
        return strongSelf.makeCellForResultSearch(tableView, at: indexPath, element: showViewModel)
      }
    })
    
    viewModel.output
      .dataSource
      .bind(to: resultView.tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
  
  func setupViewModel() {
    
    viewModel.output
      .viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.configView(with: state)
      })
      .disposed(by: disposeBag)
    
    setupDataSource()
    
    Observable
      .zip(resultView.tableView.rx.itemSelected,
           resultView.tableView.rx.modelSelected(ResultSearchSectionItem.self))
      .subscribe(onNext: { [weak self] (index, element) in
        guard let strongSelf = self else { return }
        
        switch element {
        case .recentSearchs :
          break
          
        case .results(let viewModel):
          strongSelf.resultView.tableView.deselectRow(at: index, animated: true)
          strongSelf.delegate?.resultsSearchViewController(strongSelf, didSelectedMovie: viewModel.entity.id)
        }
      })
      .disposed(by: disposeBag)
  }
  
  func configView(with state: SimpleViewState<TVShowCellViewModel>) {
    
    let tableView = resultView.tableView
    
    switch state {
    case .populated :
      tableView.tableFooterView = nil
      tableView.separatorStyle = .singleLine
    //tableView.reloadData()
    case .empty :
      tableView.tableFooterView = emptyView
      tableView.separatorStyle = .none
    //tableView.reloadData()
    case .paging :
      tableView.tableFooterView = loadingView
      tableView.separatorStyle = .singleLine
    //tableView.reloadData()
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
