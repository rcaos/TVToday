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
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    setupTable()
    setupViewModel()
  }
  
  func setupViews() {
    emptyView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
    loadingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
  }
  
  func setupTable() {
    resultView.tableView.registerNib(cellType: TVShowViewCell.self)
  }
  
  // MARK: - SetupViewModel
  
  func setupViewModel() {
    
    viewModel.output
      .viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.configView(with: state)
      })
      .disposed(by: disposeBag)
    
    viewModel.output
      .viewState
      .map { $0.currentEntities }
      .bind(to:
        resultView.tableView.rx.items(
          cellIdentifier: "TVShowViewCell",
          cellType: TVShowViewCell.self )) { [weak self] (index, element, cell) in
        guard let strongSelf = self else { return }
        
        cell.viewModel = element
        
        // MARK: - TODO, call "showsObservableSubject" dont be stay here
        if case .paging(let entities, let nextPage) = try? strongSelf.viewModel.viewStateObservableSubject.value(),
          index == entities.count - 1 {
          strongSelf.viewModel.searchShows(for: nextPage)
        }
    }
    .disposed(by: disposeBag)
    
    Observable
      .zip(resultView.tableView.rx.itemSelected,
           resultView.tableView.rx.modelSelected(TVShowCellViewModel.self))
      .subscribe(onNext: { [weak self] (index, element) in
        guard let strongSelf = self else { return }
        strongSelf.resultView.tableView.deselectRow(at: index, animated: true)
        strongSelf.delegate?.resultsSearchViewController(strongSelf, didSelectedMovie: element.entity.id)
      })
      .disposed(by: disposeBag)
  }
  
  func configView(with state: SimpleViewState<TVShowCellViewModel>) {
    
    let tableView = resultView.tableView
    
    switch state {
    case .populated :
      tableView.tableFooterView = nil
      tableView.separatorStyle = .singleLine
      tableView.reloadData()
    case .empty :
      tableView.tableFooterView = emptyView
      tableView.separatorStyle = .none
      tableView.reloadData()
    case .paging :
      tableView.tableFooterView = loadingView
      tableView.separatorStyle = .singleLine
      tableView.reloadData()
    default:
      tableView.tableFooterView = loadingView
    }
  }
}
