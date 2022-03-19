//
//  ProfileRootView.swift
//  AccountTV
//
//  Created by Jeans Ruiz on 8/21/20.
//

import Shared
import UIKit
import RxSwift

class ProfileRootView: NiblessView {

  private let viewModel: ProfileViewModelProtocol

  let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedSectionHeaderHeight = 40
    tableView.tableFooterView = UIView()
    return tableView
  }()

  typealias DataSource = UITableViewDiffableDataSource<ProfileSectionView, ProfilesSectionItem>
  typealias Snapshot = NSDiffableDataSourceSnapshot<ProfileSectionView, ProfilesSectionItem>
  private var dataSource: DataSource?

  private let disposeBag = DisposeBag()

  // MARK: - Initializer
  init(frame: CGRect = .zero, viewModel: ProfileViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)

    addSubview(tableView)
    setupView()
  }

  private func setupView() {
    setupTableView()
    setupDataSource()
    subscribe()
  }

  private func setupTableView() {
    tableView.delegate = self
    tableView.registerCell(cellType: ProfileTableViewCell.self)
    tableView.registerCell(cellType: GenericViewCell.self)
    tableView.registerCell(cellType: LogoutTableViewCell.self)
  }

  private func setupDataSource() {
    dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, model in
      guard let strongSelf = self else { fatalError() }

      switch model {
      case .userInfo(number: let accountInfo):
        return strongSelf.buildCellForProfileInfo(tableView, at: indexPath, element: accountInfo)

      case .userLists(items: let title):
        return strongSelf.buildCellForUserLists(tableView, at: indexPath, element: title)

      case .logout(items: let title):
        return strongSelf.buildLogOutCell(tableView, at: indexPath, element: title)
      }
    })
  }

  private func subscribe() {
    viewModel
      .dataSource
      .map { dataSource -> Snapshot in
        var snapShot = Snapshot()
        for element in dataSource {
          snapShot.appendSections([element.sectionView])
          snapShot.appendItems(element.items, toSection: element.sectionView)
        }
        return snapShot
      }
      .subscribe(onNext: { [weak self] snapshot in
        self?.dataSource?.apply(snapshot)
      })
      .disposed(by: disposeBag)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    tableView.frame = bounds
  }

  // MARK: - Build Cells
  private func buildCellForProfileInfo(_ tableView: UITableView, at indexPath: IndexPath, element: AccountResult) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: ProfileTableViewCell.self, for: indexPath)
    cell.setModel(with: element)
    return cell
  }

  private func buildCellForUserLists(_ tableView: UITableView, at indexPath: IndexPath, element: UserListType) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: GenericViewCell.self, for: indexPath)
    cell.setTitle(with: element.rawValue)
    return cell
  }

  private func buildLogOutCell(_ tableView: UITableView, at indexPath: IndexPath, element: String) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: LogoutTableViewCell.self, for: indexPath)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ProfileRootView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat(40)
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if let model = dataSource?.itemIdentifier(for: indexPath) {
      viewModel.tapCellAction.onNext(model)
    }
  }
}
