//
//  ProfileViewController.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import Shared

class ProfileViewController: UIViewController, StoryboardInstantiable {
  
  private var viewModel: ProfileViewModelProtocol!
  
  static func create(with viewModel: ProfileViewModelProtocol) -> ProfileViewController {
    let controller = ProfileViewController.instantiateViewController(fromStoryBoard: "AccountViewController")
    controller.viewModel = viewModel
    return controller
  }
  
  @IBOutlet weak var tableView: UITableView!
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func setupUI() {
    registerCells()
    setupDataSource()
    setupBindables()
  }
  
  fileprivate func registerCells() {
    tableView.registerNib(cellType: ProfileTableViewCell.self)
    tableView.registerNib(cellType: GenericViewCell.self)
    tableView.registerCell(cellType: LogoutTableViewCell.self)
    
    tableView.tableFooterView = UIView()
    tableView.rowHeight = UITableView.automaticDimension
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
  
  fileprivate func setupBindables() {
    viewModel
      .presentSignOutAlert
      .filter { $0 == true }
      .subscribe(onNext: { [weak self] _ in
        self?.showSignOutActionSheet()
      })
      .disposed(by: disposeBag)
    
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
  
  private func showSignOutActionSheet() {
    let signOutAction = UIAlertAction(title: "Sign out",
                                      style: .destructive) { [weak self] _ in
                                        self?.viewModel.didTapLogoutButton()
    }
    
    let actionSheet = UIAlertController(title: "Are you sure you want to Sign out?",
                                        message: nil,
                                        preferredStyle: .actionSheet)
    let cancelTitle = "Cancel"
    let cancelActionButton = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
      self.dismiss(animated: true)
    }
    actionSheet.addAction(cancelActionButton)
    actionSheet.addAction(signOutAction)
    present(actionSheet, animated: true, completion: nil)
  }
}

// MARK: - Build Cells

extension ProfileViewController {
  
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

extension ProfileViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat(40)
  }
}
