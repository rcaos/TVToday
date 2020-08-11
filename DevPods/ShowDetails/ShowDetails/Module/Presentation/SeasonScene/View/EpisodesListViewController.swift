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

class EpisodesListViewController: UIViewController, StoryboardInstantiable, Loadable, Retryable {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var viewModel: EpisodesListViewModelProtocol!
  
  let loadingView = LoadingView(frame: .zero)
  let emptyView = MessageImageView(message: "No episodes available", image: "tvshowEmpty")
  let errorView = MessageImageView(message: "Unable to connect to server", image: "error")
  
  static func create(with viewModel: EpisodesListViewModelProtocol) -> EpisodesListViewController {
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
    viewModel.viewDidLoad()
    
    title = "All Episodes"
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  private func configureTable() {
    tableView.registerNib(cellType: HeaderSeasonsTableViewCell.self)
    tableView.registerNib(cellType: SeasonListTableViewCell.self)
    tableView.registerNib(cellType: EpisodeItemTableViewCell.self)
  }
  
  private func setupBindables() {
    viewModel
      .viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.configureView(with: state)
      })
      .disposed(by: disposeBag)
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<SeasonsSectionModel>(
      configureCell: { [weak self] (_, _, indexPath, element) -> UITableViewCell in
        guard let strongSelf = self else { fatalError() }
        switch element {
        case .headerShow(viewModel: let viewModel):
          return strongSelf.makeCellForHeaderShow(at: indexPath, viewModel: viewModel)
        case .seasons(number: let numberOfSeasons):
          return strongSelf.makeCellForSeasonNumber(at: indexPath, element: numberOfSeasons)
        case .episodes(items: let episode):
          return strongSelf.makeCellForEpisode(at: indexPath, element: episode)
        }
    })
    
    viewModel
      .data
      .bind(to: tableView.rx.items(dataSource: dataSource) )
      .disposed(by: disposeBag)
    
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  private func configureView(with state: EpisodesListViewModel.ViewState) {
    
    switch state {
    case .loading :
      showLoadingView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .none
      hideMessageView()
      
    case .populated :
      hideLoadingView()
      tableView.tableFooterView = UIView()
      tableView.separatorStyle = .none
      hideMessageView()
      
    case .loadingSeason:
      hideLoadingView()
      tableView.tableFooterView = loadingView
      tableView.separatorStyle = .none
      hideMessageView()
      
    case .empty :
      hideLoadingView()
      tableView.tableFooterView = emptyView
      tableView.separatorStyle = .none
      
    case .error(let message):
      hideLoadingView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .none
      showMessageView(with: message,
                      errorHandler: { [weak self] in
                        self?.viewModel.refreshView()
      })
      
    case .errorSeason:
      hideLoadingView()
      tableView.tableFooterView = errorView
      tableView.separatorStyle = .none
      hideMessageView()
    }
  }
}

// MARK: - Confgure Cells

extension EpisodesListViewController {
  
  private func makeCellForHeaderShow(at indexPath: IndexPath, viewModel: SeasonHeaderViewModelProtocol) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: HeaderSeasonsTableViewCell.self, for: indexPath)
    if cell.viewModel == nil {
      cell.viewModel = viewModel
    }
    return cell
  }
  
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
    
    switch indexPath.section {
    case 0:
      return UITableView.automaticDimension
    case 1:
      return 65.0
    default:
      return 110.0
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
