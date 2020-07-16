//
//  TVShowListViewController.swift
//  MyTvShows
//
//  Created by Jeans on 8/26/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Shared

class TVShowListViewController: UIViewController, StoryboardInstantiable, Loadable, PresentableView {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var viewModel: TVShowListViewModel!
  
  private let disposeBag = DisposeBag()
  
  static func create(with viewModel: TVShowListViewModel) -> TVShowListViewController {
    let controller = TVShowListViewController.instantiateViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTable()
    setupViewModel()
    viewModel.getShows(for: 1)
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  // MARK: - SetupTable
  
  func setupTable() {
    tableView.registerNib(cellType: TVShowViewCell.self)
    
    tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  // MARK: - SetupViewModel
  
  private func setupViewModel() {
    subscribeToViewState()
    subscribeToData()
    handleSelectionItems()
  }
  
  private func subscribeToViewState() {
    viewModel.output
      .viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.configView(with: state)
      })
      .disposed(by: disposeBag)
  }
  
  private func subscribeToData() {
    viewModel.output
      .viewState
      .map { $0.currentEntities }
      .bind(to: tableView.rx.items(cellIdentifier: "TVShowViewCell", cellType: TVShowViewCell.self )) { [weak self] (index, element, cell) in
        guard let strongSelf = self else { return }
        
        cell.viewModel = element
        
        // MARK: - TODO, call "showsObservableSubject" dont be stay here
        if case .paging(let entities, let nextPage) = try? strongSelf.viewModel.viewStateObservableSubject.value(),
          index == entities.count - 1 {
          strongSelf.viewModel.getShows(for: nextPage)
        }
    }
    .disposed(by: disposeBag)
  }
  
  private func handleSelectionItems() {
    Observable
      .zip( tableView.rx.itemSelected, tableView.rx.modelSelected(TVShowCellViewModel.self) )
      .bind { [weak self] (indexPath, item) in
        guard let strongSelf = self else { return }
        strongSelf.tableView.deselectRow(at: indexPath, animated: true)
        strongSelf.viewModel.navigateTo(step: TVShowListStep.showIsPicked(showId: item.entity.id) )
    }
    .disposed(by: disposeBag)
  }
  
  private func configView(with state: SimpleViewState<TVShowCellViewModel>) {
    
    switch state {
    case .loading:
      showLoadingView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .none
      hideMessageView()
      
    case .paging :
      hideLoadingView()
      tableView.tableFooterView = LoadingView.defaultView
      tableView.separatorStyle = .singleLine
      hideMessageView()
      
    case .populated :
      hideLoadingView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .singleLine
      hideMessageView()
      
    case .empty:
      hideLoadingView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .none
      showMessageView(with: "No TvShows to show")
      
    case .error(let error):
      hideLoadingView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .none
      showMessageView(with: error)
    }
  }
}

// MARK: - UITableViewDelegate

extension TVShowListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 175.0
  }
}
