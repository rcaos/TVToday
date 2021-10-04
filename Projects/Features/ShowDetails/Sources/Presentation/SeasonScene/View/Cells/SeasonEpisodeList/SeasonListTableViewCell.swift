//
//  SeasonEpisodeTableViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/24/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import Shared
import RxDataSources

class SeasonListTableViewCell: NiblessTableViewCell {

  private let collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.isScrollEnabled = false
    collectionView.backgroundColor = .white
    return collectionView
  }()

  var viewModel: SeasonListViewModelProtocol?

  private var disposeBag = DisposeBag()

  // MARK: - Life Cycle
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  private func setupUI() {
    constructHierarchy()
    activateConstraints()
    configureViews()
  }

  private func constructHierarchy() {
    addSubview(collectionView)
  }

  private func activateConstraints() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.pin(to: self)
  }

  private func configureViews() {
    collectionView.allowsMultipleSelection = false
    collectionView.registerNib(cellType: SeasonEpisodeCollectionViewCell.self, bundle: Bundle.module)

    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
  }

  public func setViewModel(viewModel: SeasonListViewModelProtocol?) {
    self.viewModel = viewModel
    setupBindables()
  }

  private func setupBindables() {
    guard let viewModel = viewModel else {
      return
    }

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

  private func selectedSeason(at index: Int) {
    let indexPath = IndexPath(row: index - 1, section: 0)
    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
  }

  private func configureCollectionViewCell() -> CollectionViewSectionedDataSource<SectionSeasonsList>.ConfigureCell {
    let configureCell: CollectionViewSectionedDataSource<SectionSeasonsList>.ConfigureCell = { [weak self] _, collectionView, indexPath, item in
      guard let strongSelf = self else {
        fatalError()
      }

      let cell = collectionView.dequeueReusableCell(with: SeasonEpisodeCollectionViewCell.self, for: indexPath)

      cell.viewModel = strongSelf.viewModel?.getModel(for: item)
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
