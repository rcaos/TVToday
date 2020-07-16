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

class TVShowListViewController: UIViewController, StoryboardInstantiable, Loadable {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var viewModel: TVShowListViewModel!
  
  private let disposeBag = DisposeBag()
  
  private var messageView = MessageView(message: "")
  
  private var loadingView = LoadingView(frame: .zero)
  
  static func create(with viewModel: TVShowListViewModel) -> TVShowListViewController {
    let controller = TVShowListViewController.instantiateViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    setupTable()
    setupViewModel()
    viewModel.getShows(for: 1)
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  // MARK: - SetupView
  
  func setupViews() {
    messageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
    loadingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
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
    hideLoadingView()
    
    switch state {
    case .loading:
      showLoadingView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .none
      
    case .paging :
      tableView.tableFooterView = loadingView
      tableView.separatorStyle = .singleLine
      
    case .populated :
      tableView.tableFooterView = nil
      tableView.separatorStyle = .singleLine
      
    case .empty:
      messageView.messageLabel.text = "No TVShow to show"
      tableView.tableFooterView = messageView
      tableView.separatorStyle = .none
      
    case .error(let error):
      messageView.messageLabel.text = error
      tableView.tableFooterView = messageView
      tableView.separatorStyle = .none
    }
  }
}

// MARK: - UITableViewDelegate

extension TVShowListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 175.0
  }
}
