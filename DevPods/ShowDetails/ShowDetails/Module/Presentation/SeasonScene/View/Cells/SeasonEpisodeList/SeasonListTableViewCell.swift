//
//  SeasonEpisodeTableViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/24/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import RxDataSources

class SeasonListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var viewModel: SeasonListViewModelProtocol? {
    didSet {
      setupBindables()
    }
  }
  
  private var disposeBag = DisposeBag()
  
  // MARK: - Life Cycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  func setupUI() {
    collectionView.allowsMultipleSelection = false
    collectionView.registerNib(cellType: SeasonEpisodeCollectionViewCell.self)
    
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  func setupBindables() {
    guard let viewModel = viewModel else { return }
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionSeasonsList>(configureCell: configureCollectionViewCell())
    
    viewModel
      .seasons
      .map { [SectionSeasonsList(header: "Seasons", items: $0 )] }
      .bind(to: collectionView.rx.items(dataSource: dataSource) )
      .disposed(by: disposeBag)
    
    collectionView.rx.modelSelected(Int.self)
      .bind(to: viewModel.inputSelectedSeason)
      .disposed(by: disposeBag)
    
    viewModel
      .seasonSelected
      .filter { $0 > 0 }
      .subscribe(onNext: { [weak self] season in
        self?.selectedSeason(at: season)
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func selectedSeason(at index: Int) {
    let indexPath = IndexPath(row: index - 1, section: 0)
    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
  }
  
  fileprivate func configureCollectionViewCell() -> CollectionViewSectionedDataSource<SectionSeasonsList>.ConfigureCell {
    
    let configureCell: CollectionViewSectionedDataSource<SectionSeasonsList>.ConfigureCell = {
      [weak self] dataSource, collectionView, indexPath, item in
      guard let strongSelf = self else { fatalError() }
      
      let cell = collectionView.dequeueReusableCell(with: SeasonEpisodeCollectionViewCell.self, for: indexPath)
      
      cell.viewModel = 
        strongSelf.viewModel?.getModel(for: item)
      return cell
    }
    return configureCell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SeasonListTableViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 50, height: 50)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    let height = collectionView.layer.frame.height
    let insetTop = (height - 50) / 2
    
    return UIEdgeInsets(top: insetTop, left: 8, bottom: insetTop, right: 0)
  }
}
