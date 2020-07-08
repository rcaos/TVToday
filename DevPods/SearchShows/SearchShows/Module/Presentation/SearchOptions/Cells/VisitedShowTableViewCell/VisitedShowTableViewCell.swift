//
//  VisitedShowTableViewCell.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/5/20.
//

import UIKit
import RxSwift
import RxDataSources
import Persistence

class VisitedShowTableViewCell: UITableViewCell {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var viewModel: VisitedShowViewModel?
  
  private var disposeBag = DisposeBag()
  
  private var preferredWidth: CGFloat = 100.0
  private var preferredHeight: CGFloat = 170.0
  
  // MARK: - Life Cycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                        verticalFittingPriority: UILayoutPriority) -> CGSize {
    collectionView.layoutIfNeeded()
    collectionView.frame = CGRect(x: 0, y: 0, width: targetSize.width, height: preferredHeight)
    return collectionView.collectionViewLayout.collectionViewContentSize
  }
  
  private func setupUI() {
    collectionView.allowsMultipleSelection = false
    collectionView.registerNib(cellType: VisitedShowCollectionViewCell.self)
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
  }
  
  func setupCell(with viewModel: VisitedShowViewModel) {
    self.viewModel = viewModel
    disposeBag = DisposeBag()
    
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<VisitedShowSectionModel>(configureCell: configureCollectionViewCell())
    
    viewModel.output
      .shows
      .map { [VisitedShowSectionModel(header: "Visited", items: $0)] }
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    collectionView.rx.modelSelected(ShowVisited.self)
      .map { $0.id }
      .bind(to: viewModel.input.selectedShow)
      .disposed(by: disposeBag)
  }
  
  fileprivate func configureCollectionViewCell() -> CollectionViewSectionedDataSource<VisitedShowSectionModel>.ConfigureCell {
    
    let configureCell: CollectionViewSectionedDataSource<VisitedShowSectionModel>.ConfigureCell = { dataSource, collectionView, indexPath, item in
      let cell = collectionView.dequeueReusableCell(with: VisitedShowCollectionViewCell.self, for: indexPath)
      cell.setupCell(with: item.pathImage)
      return cell
    }
    return configureCell
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
