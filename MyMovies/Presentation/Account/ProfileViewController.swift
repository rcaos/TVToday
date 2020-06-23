//
//  ProfileViewController.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import RxDataSources

class ProfileViewController: UIViewController, StoryboardInstantiable {
  
  private var viewModel: ProfileViewModel!
  
  static func create(with viewModel: ProfileViewModel) -> ProfileViewController {
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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("viewDidAppear ProfileViewController")
  }
  
  private func setupUI() {
    registerCells()
    setupDataSource()
    setupBindables()
  }
  
  fileprivate func registerCells() {
    let profileNib = UINib(nibName: ProfileTableViewCell.identifier, bundle: nil)
    tableView.register(profileNib, forCellReuseIdentifier: ProfileTableViewCell.identifier)
    
    let genericNib = UINib(nibName: GenreViewCell.identifier, bundle: nil)
    tableView.register(genericNib, forCellReuseIdentifier: GenreViewCell.identifier)
    
    tableView.register(LogoutTableViewCell.self, forCellReuseIdentifier: LogoutTableViewCell.identifier)
    
    tableView.tableFooterView = UIView()
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
    
    viewModel.output
    .sections
    .bind(to: tableView.rx.items(dataSource: dataSource))
    .disposed(by: disposeBag)
  }
  
  fileprivate func setupBindables() {
    viewModel.output
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
      .bind(to: viewModel.input.tapCellAction)
      .disposed(by: disposeBag)
  }
  
  private func showSignOutActionSheet() {
    let signOutAction = UIAlertAction(title: "Sign out",
                                      style: .destructive) { [weak self] _ in
                                        self?.viewModel.input.tapLogoutAction.onNext(())
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
    let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
    cell.configCell(with: element)
    return cell
  }
  
  fileprivate func buildCellForUserLists(at indexPath: IndexPath, element: UserListType) -> UITableViewCell {
    // TODO Rename Genre Cell
    let cell = tableView.dequeueReusableCell(withIdentifier: GenreViewCell.identifier, for: indexPath) as! GenreViewCell
    cell.genre = Genre(id: 0, name: element.rawValue)
    return cell
  }
  
  fileprivate func buildLogOutCell(at indexPath: IndexPath, element: String) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: LogoutTableViewCell.identifier, for: indexPath) as! LogoutTableViewCell
    return cell
  }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat(40)
  }
}
