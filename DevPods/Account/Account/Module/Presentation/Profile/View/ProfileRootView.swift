//
//  ProfileRootView.swift
//  AccountTV
//
//  Created by Jeans Ruiz on 8/21/20.
//

import Shared
import UIKit
import RxSwift
import RxDataSources

class ProfileRootView: NiblessView {
  
  private let viewModel: ProfileViewModelProtocol
  
  let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedSectionHeaderHeight = 40
    tableView.tableFooterView = UIView()
    return tableView
  }()
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializer
  
  init(frame: CGRect = .zero, viewModel: ProfileViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)
    
    addSubview(tableView)
    setupView()
  }
  
  fileprivate func setupView() {
    setupTableView()
    registerCells()
    setupDataSource()
  }
  
  fileprivate func setupTableView() {
    tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    tableView.rx.itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        self?.tableView.deselectRow(at: indexPath, animated: true)
      })
      .disposed(by: disposeBag)
    
    tableView.rx.modelSelected(ProfilesSectionItem.self)
      .bind(to: viewModel.tapCellAction)
      .disposed(by: disposeBag)
  }
  
  fileprivate func registerCells() {
    tableView.registerNib(cellType: ProfileTableViewCell.self)
    tableView.registerNib(cellType: GenericViewCell.self)
    tableView.registerCell(cellType: LogoutTableViewCell.self)
  }
  
  fileprivate func setupDataSource() {
    let dataSource = RxTableViewSectionedReloadDataSource<ProfileSectionModel>(configureCell: { [weak self] (_, _, indexPath, element) -> UITableViewCell in
      guard let strongSelf = self else { fatalError() }
      
      switch element {
      case .userInfo(number: let accountInfo):
        return strongSelf.buildCellForProfileInfo(at: indexPath, element: accountInfo)
        
      case .userLists(items: let title):
        return strongSelf.buildCellForUserLists(at: indexPath, element: title)
        
      case .logout(items: let title):
        return strongSelf.buildLogOutCell(at: indexPath, element: title)
        
      }
    })
    
    viewModel
      .dataSource
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    tableView.frame = bounds
  }
}

// MARK: - Build Cells

extension ProfileRootView {
  
  fileprivate func buildCellForProfileInfo(at indexPath: IndexPath, element: AccountResult) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: ProfileTableViewCell.self, for: indexPath)
    cell.configCell(with: element)
    return cell
  }
  
  fileprivate func buildCellForUserLists(at indexPath: IndexPath, element: UserListType) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: GenericViewCell.self, for: indexPath)
    cell.setupUI(with: element.rawValue)
    return cell
  }
  
  fileprivate func buildLogOutCell(at indexPath: IndexPath, element: String) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: LogoutTableViewCell.self, for: indexPath)
    return cell
  }
}

// MARK: - UITableViewDelegate

extension ProfileRootView: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat(40)
  }
}
