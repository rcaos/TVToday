//
//  SeasonEpisodeTableViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/24/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

protocol SeasonListTableViewCellDelegate: class {
  
  func didSelectedSeason(at season: Int)
}

class SeasonListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var viewModel: SeasonListViewModel? {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.setupBindables()
      }
    }
  }
  
  weak var delegate: SeasonListTableViewCellDelegate?
  
  private var disposeBag = DisposeBag()
  
  // MARK: - Life Cycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  func setupUI() {
    collectionView.allowsMultipleSelection = false
    
    let nibName = UINib(nibName: "SeasonEpisodeCollectionViewCell", bundle: nil)
    collectionView.register(nibName, forCellWithReuseIdentifier: "SeasonEpisodeCollectionViewCell")
    
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  func setupBindables() {
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionSeasonsList>(configureCell: configureCollectionViewCell())
    
    viewModel?.output
      .seasons
      .map { [SectionSeasonsList(header: "Seasons", items: $0 )] }
      .bind(to: collectionView.rx.items(dataSource: dataSource) )
      .disposed(by: disposeBag)
    
    collectionView.rx
      .modelSelected(Int.self)
      .subscribe(onNext: { [weak self] season in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.didSelectedSeason(at: season)
      })
      .disposed(by: disposeBag)
    
    viewModel?.output.seasonSelected
      .filter { $0 > 0 }
      .subscribe(onNext: { [weak self] season in
        guard let strongSelf = self else { return }
        DispatchQueue.main.async {
          strongSelf.selectedSeason(at: season)
        }
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
      
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: "SeasonEpisodeCollectionViewCell", for: indexPath) as! SeasonEpisodeCollectionViewCell
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
