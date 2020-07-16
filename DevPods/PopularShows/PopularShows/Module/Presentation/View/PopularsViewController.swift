//
//  PupularShowsViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Shared

class PopularsViewController: UIViewController, StoryboardInstantiable, Loadable, PresentableView {
  
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel: PopularViewModel!
  
  static func create(with viewModel: PopularViewModel) -> PopularsViewController {
    let controller = PopularsViewController.instantiateViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  let disposeBag = DisposeBag()
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupViewModel()
    viewModel.getShows(for: 1)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = false
  }
  
  // MARK: - Setup UI
  
  func setupUI() {
    navigationItem.title = "Popular TV Shows"
    setupTable()
  }
  
  func setupTable() {
    tableView.registerNib(cellType: TVShowViewCell.self)
    
    tableView.tableFooterView = nil
    tableView.rowHeight = UITableView.automaticDimension
    
    tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  // MARK: - Setup ViewModel
  
  func setupViewModel() {
    viewModel.output
      .viewState
      .map { $0.currentEntities }
      .bind(to:
        tableView.rx.items( cellIdentifier: "TVShowViewCell",
                            cellType: TVShowViewCell.self)) { [weak self] (index, element, cell) in
                              guard let strongSelf = self else { return }
                              
                              cell.viewModel = element
                              
                              if case .paging(let entities, let nextPage) = try? strongSelf.viewModel.viewStateObservableSubject.value(),
                                index == entities.count - 1 {
                                strongSelf.viewModel.getShows(for: nextPage)
                              }
    }
    .disposed(by: disposeBag)
    
    viewModel.output
      .viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.handleTableState(with: state)
      })
      .disposed(by: disposeBag)
    
    Observable
      .zip( tableView.rx.itemSelected, tableView.rx.modelSelected(TVShowCellViewModel.self) )
      .bind { [weak self] (indexPath, item) in
        guard let strongSelf = self else { return }
        strongSelf.tableView.deselectRow(at: indexPath, animated: true)
        strongSelf.viewModel.navigateTo(step: PopularStep.showIsPicked(withId: item.entity.id) )
    }
    .disposed(by: disposeBag)
  }
  
  fileprivate func handleTableState(with state: SimpleViewState<TVShowCellViewModel>) {
    
    switch state {
    case .loading:
      showLoadingView()
      hideMessageView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .none
      
    case .paging:
      hideLoadingView()
      hideMessageView()
      tableView.tableFooterView = LoadingView.defaultView
      tableView.separatorStyle = .singleLine
      
    case .populated:
      hideLoadingView()
      hideMessageView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .singleLine
      
    case .empty:
      hideLoadingView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .none
      showMessageView(with: "No TVshow to show")
      
    case .error(let error):
      hideLoadingView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .none
      showMessageView(with: error)
    }
  }
}

// MARK: - UITableViewDelegate

extension PopularsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 175.0
  }
}
