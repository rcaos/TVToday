//
//  SearchOptionsViewController.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/7/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Shared

class SearchOptionsViewController: UIViewController, StoryboardInstantiable, Loadable {
  
  @IBOutlet var tableView: UITableView!
  
  private var viewModel: SearchOptionsViewModel!
  
  private var messageView = MessageView(frame: .zero)
  
  private let disposeBag = DisposeBag()
  
  static func create(with viewModel: SearchOptionsViewModel) -> SearchOptionsViewController {
    let controller = SearchOptionsViewController.instantiateViewController(fromStoryBoard: "SearchViewController")
    controller.viewModel = viewModel
    return controller
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    viewModel.viewDidLoad()
  }
  
  private func setupUI() {
    setupViews()
    registerCells()
    bindViewState()
    setupTable()
  }
  
  private func setupViews() {
    messageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
  }
  
  private func registerCells() {
    tableView.registerNib(cellType: VisitedShowTableViewCell.self)
    tableView.registerNib(cellType: GenreTableViewCell.self)
    tableView.rowHeight = UITableView.automaticDimension
  }
  
  private func bindViewState() {
    viewModel.output.viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.handleTableState(with: state)
      })
      .disposed(by: disposeBag)
  }
  
  private func setupTable() {
    setupDataSource()
    handleSelection()
  }
  
  private func setupDataSource() {
    let dataSource = RxTableViewSectionedReloadDataSource<SearchOptionsSectionModel>(
      configureCell: { [weak self] (_, _, indexPath, element) -> UITableViewCell in
        guard let strongSelf = self else { fatalError() }
        switch element {
        case .showsVisited(items: let viewModel):
          return strongSelf.makeCellForShowVisited(at: indexPath, cellViewModel: viewModel)
        case .genres(items: let genre):
          return strongSelf.makeCellForGenre(at: indexPath, element: genre)
        }
    })
    
    dataSource.titleForHeaderInSection = { dataSource, section in
      return dataSource.sectionModels[section].getHeader()
    }
    
    viewModel.output
      .dataSource
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
  
  private func handleSelection() {
    Observable
      .zip( tableView.rx.itemSelected, tableView.rx.modelSelected(SearchOptionsSectionModel.Item.self) )
      .bind { [weak self] (indexPath, item) in
        guard let strongSelf = self else { return }
        strongSelf.tableView.deselectRow(at: indexPath, animated: true)
        strongSelf.viewModel.modelIsPicked(with: item)
    }
    .disposed(by: disposeBag)
  }
  
  private func handleTableState(with state: SimpleViewState<GenreViewModel>) {
    hideLoadingView()
    
    switch state {
    case .loading:
      showLoadingView()
      tableView.tableFooterView = nil
      tableView.separatorStyle = .none
      
    case .paging:
      tableView.tableFooterView = LoadingView.defaultView
      tableView.separatorStyle = .singleLine
      
    case .populated:
      tableView.tableFooterView = nil
      tableView.separatorStyle = .singleLine
      
    case .empty:
      messageView.messageLabel.text = "No genres to Show"
      tableView.tableFooterView = messageView
      tableView.separatorStyle = .none
      
    case .error(let message):
      messageView.messageLabel.text = message
      tableView.tableFooterView = messageView
      tableView.separatorStyle = .none
    }
  }
}

// MARK: - Build Cells

extension SearchOptionsViewController {
  
  private func makeCellForShowVisited(at indexPath: IndexPath, cellViewModel: VisitedShowViewModel) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: VisitedShowTableViewCell.self, for: indexPath)
    cellViewModel.delegate = viewModel
    cell.setupCell(with: cellViewModel)
    return cell
  }
  
  private func makeCellForGenre(at indexPath: IndexPath, element: GenreViewModel) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: GenreTableViewCell.self, for: indexPath)
    cell.viewModel = element
    return cell
  }
}
