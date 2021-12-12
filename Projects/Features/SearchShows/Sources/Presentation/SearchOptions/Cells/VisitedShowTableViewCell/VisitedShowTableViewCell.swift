//
//  VisitedShowTableViewCell.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/5/20.
//

import UIKit
import RxSwift
import RxDataSources
import Shared
import Persistence

class VisitedShowTableViewCell: NiblessTableViewCell {

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isScrollEnabled = true
    collectionView.allowsMultipleSelection = false
    collectionView.backgroundColor = .systemBackground
    return collectionView
  }()

  var viewModel: VisitedShowViewModelProtocol?

  private var disposeBag = DisposeBag()

  private var preferredWidth: CGFloat = 100.0
  private var preferredHeight: CGFloat = 170.0

  // MARK: - Life Cycle
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                        verticalFittingPriority: UILayoutPriority) -> CGSize {
    collectionView.layoutIfNeeded()
    collectionView.frame = CGRect(x: 0, y: 0, width: targetSize.width, height: preferredHeight)
    return collectionView.collectionViewLayout.collectionViewContentSize
  }

  func setupCell(with viewModel: VisitedShowViewModelProtocol) {
    self.viewModel = viewModel
    disposeBag = DisposeBag()

    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)

    let dataSource = RxCollectionViewSectionedReloadDataSource<VisitedShowSectionModel>(configureCell: configureCollectionViewCell())

    viewModel
      .shows
      .map { [VisitedShowSectionModel(header: "Visited", items: $0)] }
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    collectionView.rx.modelSelected(ShowVisited.self)
      .map { $0.id }
      .bind(to: viewModel.selectedShow)
      .disposed(by: disposeBag)
  }

  fileprivate func configureCollectionViewCell() -> CollectionViewSectionedDataSource<VisitedShowSectionModel>.ConfigureCell {
    let configureCell: CollectionViewSectionedDataSource<VisitedShowSectionModel>.ConfigureCell = { _, collectionView, indexPath, item in
      let cell = collectionView.dequeueReusableCell(with: VisitedShowCollectionViewCell.self, for: indexPath)
      cell.setModel(imageURL: item.pathImage)
      return cell
    }
    return configureCell
  }

  private func setupUI() {
    constructHierarchy()
    activateConstraints()
    configureViews()
  }

  private func configureViews() {
    collectionView.registerCell(cellType: VisitedShowCollectionViewCell.self)
  }

  private func constructHierarchy() {
    contentView.addSubview(collectionView)
  }

  private func activateConstraints() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.pin(to: contentView)
  }
}

// MARK: UICollectionViewDelegateFlowLayout
extension VisitedShowTableViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: preferredWidth, height: preferredHeight)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
  }
}
