//
//  SeasonsListViewController.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

private let reuseIdentifierForEpisode = "identifierForEpisodeSeason"
private let reuseIdentifierForSeasons = "identifierForSeason"

class SeasonsListViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var viewModel: SeasonsListViewModel!
  private var seasonsListViewControllers: SeasonsListViewControllersFactory!
  
  let loadingView = LoadingView(frame: .zero)
  
  static func create(with viewModel: SeasonsListViewModel,
                     seasonsListViewControllers: SeasonsListViewControllersFactory) -> SeasonsListViewController {
    let controller = SeasonsListViewController.instantiateViewController()
    controller.viewModel = viewModel
    controller.seasonsListViewControllers = seasonsListViewControllers
    return controller
  }
  
  private let disposeBag = DisposeBag()
  
  //MARK: - Life Cycle
  
  override func loadView() {
    super.loadView()
    loadingView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTable()
    setupBindables()
    viewModel?.getShowDetails()
  }
  
  deinit {
    print("deinit child DefaultSeasonTableViewController")
  }
  
  private func configureTable() {
    let nibName = UINib(nibName: "SeasonListTableViewCell", bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: reuseIdentifierForEpisode)
    
    let nibColl = UINib(nibName: "SeasonEpisodeTableViewCell", bundle: nil)
    tableView.register(nibColl, forCellReuseIdentifier: reuseIdentifierForSeasons)
  }
  
  private func setupTableHeaderView() {
    let nib = UINib(nibName: "SeasonHeaderView", bundle: nil)
    let headerView = nib.instantiate(withOwner: nil, options: nil).first as! SeasonHeaderView
    headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 150)
    headerView.viewModel = viewModel.buildHeaderViewModel()
    
    tableView.tableHeaderView = headerView
  }
  
  // MARK: - TODO dont be here
  func buildEmptyView() -> UIView {
    
    let frame = CGRect(x: 0, y: 0, width: tableView.frame.height, height: 200)
    let nib = UINib(nibName: "EmptyView", bundle: nil)
    
    let emptyView = nib.instantiate(withOwner: nil, options: nil).first as! EmptyView
    emptyView.frame = frame
    
    return emptyView
  }
  
  // MARK: - TODO dont be here
  func buildErrorView() -> UIView {
    
    let frame = CGRect(x: 0, y: 0, width: tableView.frame.height, height: 200)
    let nib = UINib(nibName: "ErrorView", bundle: nil)
    
    let emptyView = nib.instantiate(withOwner: nil, options: nil).first as! ErrorView
    emptyView.frame = frame
    
    return emptyView
  }
  
  private func setupBindables() {
    viewModel.viewState.observe(on: self) {[weak self] state in
      self?.configureView(with: state)
    }
    
    viewModel.didLoad.observe(on: self) { [weak self] didAppear in
      guard didAppear else { return }
      self?.setupTableHeaderView()
    }
    
    let dataSource = RxTableViewSectionedReloadDataSource<SeasonsSectionModel>(
      configureCell: { [weak self] (_, tableView, indexPath, element) -> UITableViewCell in
        guard let strongSelf = self else { fatalError() }
        switch element {
        case .seasons(number: let numberOfSeasons):
          return strongSelf.makeCellForSeasonNumber(at: indexPath, element: numberOfSeasons)
        case .episodes(items: let episode):
          return strongSelf.makeCellForEpisode(at: indexPath, element: episode)
        }
    })
    
    viewModel.output
      .data
      .bind(to: tableView.rx.items(dataSource: dataSource) )
      .disposed(by: disposeBag)
    
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  private func configureView(with state: SeasonsListViewModel.ViewState) {
    
    switch state {
    case .populated:
      print("Populated state")
      tableView.tableFooterView = UIView()
      tableView.separatorStyle = .singleLine
    case .empty:
      tableView.tableFooterView = buildEmptyView()
      tableView.separatorStyle = .none
    case .error(_):
      tableView.tableFooterView = buildErrorView()
      tableView.separatorStyle = .none
    default:
      tableView.tableFooterView = loadingView
      tableView.separatorStyle = .none
    }
  }
  
  func reloadSection(at section: Int) {
    let index = IndexSet(integer: section)
    tableView.beginUpdates()
    tableView.reloadSections(index, with: .automatic)
    tableView.endUpdates()
  }
}

// MARK: - Confgure Cells

extension SeasonsListViewController {
  
  private func makeCellForSeasonNumber(at indexPath: IndexPath, element: Int) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierForSeasons, for: indexPath) as! SeasonEpisodeTableViewCell
    cell.viewModel = viewModel.buildModelForSeasons(with: element)
    cell.delegate = self
    return cell
  }
  
  private func makeCellForEpisode(at indexPath: IndexPath, element: Episode) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierForEpisode, for: indexPath) as! SeasonListTableViewCell
    
    if let model = viewModel.getModel(for: element) {
      cell.viewModel = model
    }
    return cell
  }
}

// MARK: - UITableViewDelegate

extension SeasonsListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let height:CGFloat = (indexPath.section == 0) ? 65.0 : 110.0
    return height
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension SeasonsListViewController: SeasonEpisodeTableViewCellDelegate {
  
  func didSelectedSeason(at index: Int) {
    viewModel.getSeason(at: index)
  }
}

// MARK: - AiringTodayViewControllersFactory

protocol SeasonsListViewControllersFactory {
  
}
