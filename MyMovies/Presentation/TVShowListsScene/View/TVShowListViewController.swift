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

class TVShowListViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var viewModel: TVShowListViewModel!
  
  private let disposeBag = DisposeBag()
  
  private var emptyView = MessageView(message: "No results to Show")
  
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
    print("deinit TVShowListViewController")
  }
  
  // MARK: - SetupView
  
  func setupViews() {
    emptyView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
    loadingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
  }
  
  // MARK: - SetupTable
  
  func setupTable() {
    let nibName = UINib(nibName: "TVShowViewCell", bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: "TVShowViewCell")
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
    
    Observable
      .zip( tableView.rx.itemSelected, tableView.rx.modelSelected(TVShowCellViewModel.self) )
      .bind { [weak self] (indexPath, item) in
        guard let strongSelf = self else { return }
        strongSelf.tableView.deselectRow(at: indexPath, animated: true)
        strongSelf.viewModel.navigateTo(step: SearchStep.showIsPicked(withId: item.entity .id) )
    }
    .disposed(by: disposeBag)
    
  }
  
  func configView(with state: SimpleViewState<TVShowCellViewModel>) {
    switch state {
    case .populated :
      tableView.tableFooterView = nil
      tableView.separatorStyle = .singleLine
      tableView.reloadData()
    case .empty:
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
