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

protocol SeasonEpisodeTableViewCellDelegate: class {
  
  func didSelectedSeason(at index: Int)
}

class SeasonEpisodeTableViewCell: UITableViewCell {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var viewModel: SeasonEpisodeTableViewModel? {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.setupBindables()
      }
    }
  }
  
  weak var delegate: SeasonEpisodeTableViewCellDelegate?
  
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
  }
  
  func setupBindables() {
    viewModel?.selectedCell = { index in
      DispatchQueue.main.async {
        self.selectedSeason(at: index)
      }
    }
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionSeasonsList>(configureCell: configureCollectionViewCell())
    
    viewModel?.output
      .seasons
      .map { [SectionSeasonsList(header: "Seasons", items: $0 )] }
      .debug()
      .bind(to: collectionView.rx.items(dataSource: dataSource) )
      .disposed(by: disposeBag)
    
    collectionView.rx
      .modelSelected(Int.self)
      .subscribe(onNext: { [weak self] season in
        guard let strongSelf = self else { return }
        print("--> seasonSelected to Delegate: \(season)")
        strongSelf.delegate?.didSelectedSeason(at: season - 1)
      })
      .disposed(by: disposeBag)
    
    collectionView.rx
    .setDelegate(self)
    .disposed(by: disposeBag)
  }
  
  func selectedSeason(at index: Int) {
    let indexPath = IndexPath(row: index - 1, section: 0)
    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
  }
  
  fileprivate func configureCollectionViewCell() -> CollectionViewSectionedDataSource<SectionSeasonsList>.ConfigureCell {
    
    let configureCell: CollectionViewSectionedDataSource<SectionSeasonsList>.ConfigureCell = {
      [weak self] dataSource, collectionView, indexPath, item in
      guard let strongSelf = self else { fatalError() }
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeasonEpisodeCollectionViewCell", for: indexPath) as! SeasonEpisodeCollectionViewCell
      cell.viewModel = strongSelf.viewModel?.getModelFor(indexPath.row)
      return cell
    }
    return configureCell
  }
  
  // MARK: - TODO. reuse cell
  override func prepareForReuse() {
    super.prepareForReuse()
    print("reuse Cell")
    disposeBag = DisposeBag()
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SeasonEpisodeTableViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 50, height: 50)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    let height = collectionView.layer.frame.height
    let insetTop = (height - 50) / 2
    
    return UIEdgeInsets(top: insetTop, left: 8, bottom: insetTop, right: 0)
  }
}
