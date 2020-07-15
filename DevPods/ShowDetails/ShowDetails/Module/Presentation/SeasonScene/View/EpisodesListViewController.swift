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
import Shared

class EpisodesListViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var viewModel: EpisodesListViewModel!
  
  let loadingView = LoadingView(frame: .zero)
  let emptyView = MessageImageView(message: "No episodes available", image: "tvshowEmpty")
  let errorView = MessageImageView(message: "Unable to connect to server", image: "error")
  
  static func create(with viewModel: EpisodesListViewModel) -> EpisodesListViewController {
    let controller = EpisodesListViewController.instantiateViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Life Cycle
  
  override func loadView() {
    super.loadView()
    loadingView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
    emptyView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200)
    errorView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTable()
    setupBindables()
    viewModel?.viewDidLoad()
    
    title = "All Episodes"
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateHeaderViewLayout()
  }
  
  private func configureTable() {
    tableView.registerNib(cellType: EpisodeItemTableViewCell.self)
    tableView.registerNib(cellType: SeasonListTableViewCell.self)
  }
  
  private func setupTableHeaderView() {
    // MARK: - TODO, handle with protocol instead NIbloadable or something
    let nib = UINib(nibName: "SeasonHeaderView", bundle: Bundle(for: Self.self) )
    let headerView = nib.instantiate(withOwner: nil, options: nil).first as! SeasonHeaderView
    
    headerView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    headerView.viewModel = viewModel.buildHeaderViewModel()
    
    tableView.tableHeaderView = headerView
  }
  
  private func setupBindables() {
    viewModel.output.viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.configureView(with: state)
      })
      .disposed(by: disposeBag)
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<SeasonsSectionModel>(
      configureCell: { [weak self] (_, _, indexPath, element) -> UITableViewCell in
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
  
  private func configureView(with state: EpisodesListViewModel.ViewState) {
    
    switch state {
    case .didLoadHeader :
      setupTableHeaderView()
    case .populated :
      tableView.tableFooterView = UIView()
      tableView.separatorStyle = .singleLine
    case .empty :
      tableView.tableFooterView = emptyView
      tableView.separatorStyle = .none
    case .error :
      tableView.tableFooterView = errorView
      tableView.separatorStyle = .none
    default :
      tableView.tableFooterView = loadingView
      tableView.separatorStyle = .none
    }
  }
  
  private func updateHeaderViewLayout() {
    guard let headerView = tableView.tableHeaderView else { return }
    let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    
    if headerView.frame.size.height != size.height {
      headerView.frame.size.height = size.height
      tableView.tableHeaderView = headerView
      tableView.layoutIfNeeded()
    }
  }
}

// MARK: - Confgure Cells

extension EpisodesListViewController {
  
  private func makeCellForSeasonNumber(at indexPath: IndexPath, element: Int) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: SeasonListTableViewCell.self, for: indexPath)
    if cell.viewModel == nil {
      cell.viewModel = viewModel.buildModelForSeasons(with: element)
    }
    return cell
  }
  
  private func makeCellForEpisode(at indexPath: IndexPath, element: EpisodeSectionModelType) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: EpisodeItemTableViewCell.self, for: indexPath)
    
    if let model = viewModel.getModel(for: element) {
      cell.viewModel = model
    }
    return cell
  }
}

// MARK: - UITableViewDelegate

extension EpisodesListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let height: CGFloat = (indexPath.section == 0) ? 65.0 : 110.0
    return height
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
