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
  }
  
  deinit {
    print("deinit DefaultSeasonTableViewController")
  }
  
  private func configureTable() {
    let nibName = UINib(nibName: "EpisodeItemTableViewCell", bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: reuseIdentifierForEpisode)
    
    let nibColl = UINib(nibName: "SeasonListTableViewCell", bundle: nil)
    tableView.register(nibColl, forCellReuseIdentifier: reuseIdentifierForSeasons)
  }
  
  private func setupTableHeaderView() {
    let nib = UINib(nibName: "SeasonHeaderView", bundle: nil)
    let headerView = nib.instantiate(withOwner: nil, options: nil).first as! SeasonHeaderView
    headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 110)
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
        print("-- ask for Cell: \(indexPath)")
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
}

// MARK: - Confgure Cells

extension EpisodesListViewController {
  
  private func makeCellForSeasonNumber(at indexPath: IndexPath, element: Int) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierForSeasons, for: indexPath) as! SeasonListTableViewCell
    if cell.viewModel == nil {
      cell.viewModel = viewModel.buildModelForSeasons(with: element)
      cell.delegate = self
    }
    return cell
  }
  
  private func makeCellForEpisode(at indexPath: IndexPath, element: EpisodeSectionModelType) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierForEpisode, for: indexPath) as! EpisodeItemTableViewCell
    
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

// MARK: - SeasonEpisodeTableViewCellDelegate

extension EpisodesListViewController: SeasonListTableViewCellDelegate {
  
  func didSelectedSeason(at season: Int) {
    viewModel.getSeason(at: season)
  }
}
