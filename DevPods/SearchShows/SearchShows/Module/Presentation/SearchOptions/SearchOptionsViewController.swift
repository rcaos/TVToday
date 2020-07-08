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

// TODO, al eliminar entidad, elimino este Module
import Persistence

class SearchOptionsViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet var tableView: UITableView!
  
  private var viewModel: SearchOptionsViewModel!
  
  private var loadingView = LoadingView(frame: .zero)
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
    loadingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
    messageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
  }
  
  private func registerCells() {
    tableView.registerNib(cellType: VisitedShowTableViewCell.self)
    tableView.registerNib(cellType: GenericViewCell.self)
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
        case .showsVisited(items: let shows):
          return strongSelf.makeCellForShowVisited(at: indexPath, element: shows)
        case .genres(items: let genre):
          return strongSelf.makeCellForGenre(at: indexPath, element: genre)
        }
    })
    
    viewModel.output
      .dataSource
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
  
  private func handleSelection() {
    tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    Observable
      .zip( tableView.rx.itemSelected, tableView.rx.modelSelected(SearchOptionsSectionModel.Item.self) )
      .bind { [weak self] (indexPath, item) in
        guard let strongSelf = self else { return }
        strongSelf.tableView.deselectRow(at: indexPath, animated: true)
        strongSelf.viewModel.modelIsPicked(with: item)
    }
    .disposed(by: disposeBag)
  }
  
  // TODO, View State, change genre
  
  private func handleTableState(with state: SimpleViewState<Genre>) {
    switch state {
    case .populated:
      tableView.tableFooterView = nil
      
    case .loading, .paging:
      tableView.tableFooterView = loadingView
      
    case .empty:
      messageView.messageLabel.text = "No genres to Show"
      tableView.tableFooterView = messageView
      
    case .error(let message):
      messageView.messageLabel.text = message
      tableView.tableFooterView = messageView
    }
  }
  
}

// MARK: - Build Cells

extension SearchOptionsViewController {
  
  // TODO, no debería pasar una Entidad, si no un ViewModel
  
  private func makeCellForShowVisited(at indexPath: IndexPath, element: [ShowVisited]) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: VisitedShowTableViewCell.self, for: indexPath)
    let cellViewModel = VisitedShowViewModel(shows: element)
    
    // MARK: - TODO
    cellViewModel.delegate = viewModel
    cell.setupCell(with: cellViewModel)
    return cell
  }
  
  private func makeCellForGenre(at indexPath: IndexPath, element: Genre) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: GenericViewCell.self, for: indexPath)
    cell.title = element.name
    return cell
  }
}

// MARK: - UITableViewDelegate

extension SearchOptionsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return indexPath.section == 0 ? 200 : UITableView.automaticDimension
  }
}
