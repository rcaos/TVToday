//
//  AiringTodayRootView.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 8/21/20.
//

import Shared
import UIKit
import RxSwift
import RxDataSources

class AiringTodayRootView: NiblessView {

  private var viewModel: AiringTodayViewModelProtocol

  private let collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.registerCell(cellType: AiringTodayCollectionViewCell.self)

    collectionView.register(FooterReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: "FooterReusableView")
    collectionView.backgroundColor = UIColor.groupTableViewBackground
    return collectionView
  }()

  private let disposeBag = DisposeBag()

  // MARK: - Initializer
  init(frame: CGRect = .zero, viewModel: AiringTodayViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)

    addSubview(collectionView)
    setupUI()
  }

  func stopRefresh() {
    collectionView.refreshControl?.endRefreshing(with: 0.5)
  }

  fileprivate func setupUI() {
    setupCollectionView()
    setupDataSource()
    handleSelectionItems()
  }

  // MARK: - Setup CollectionView
  fileprivate func setupCollectionView() {
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)

    collectionView.refreshControl = DefaultRefreshControl(refreshHandler: { [weak self] in
      self?.viewModel.refreshView()
    })
  }

  fileprivate func setupDataSource() {
    let (configureCollectionViewCell, configureSupplementaryView) = configureCollectionViewDataSource()

    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionAiringToday>(
      configureCell: configureCollectionViewCell,
      configureSupplementaryView: configureSupplementaryView)

    viewModel
      .viewState
      .map { [SectionAiringToday(header: "Shows Today", items: $0.currentEntities) ] }
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }

  fileprivate func handleSelectionItems() {
    collectionView.rx
      .modelSelected( AiringTodayCollectionViewModel.self)
      .subscribe(onNext: { [weak self] item in
        guard let strongSelf = self else { return }
        strongSelf.viewModel.showIsPicked(with: item.show.id)
      })
      .disposed(by: disposeBag)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    collectionView.frame = bounds
  }
}

// MARK: - Configure CollectionView Views
extension AiringTodayRootView {
  func configureCollectionViewDataSource() -> (
    CollectionViewSectionedDataSource<SectionAiringToday>.ConfigureCell,
    CollectionViewSectionedDataSource<SectionAiringToday>.ConfigureSupplementaryView
  ) {
    let configureCell: CollectionViewSectionedDataSource<SectionAiringToday>.ConfigureCell = { [weak self] dataSource, collectionView, indexPath, item in
      guard let strongSelf = self else {
        fatalError()
      }

      let cell = collectionView.dequeueReusableCell(with: AiringTodayCollectionViewCell.self, for: indexPath)
      cell.setViewModel(item)

      if let totalItems = dataSource.sectionModels.first?.items.count, indexPath.row == totalItems - 1 {
        strongSelf.viewModel.didLoadNextPage()
      }

      return cell
    }

    let configureFooterView: CollectionViewSectionedDataSource<SectionAiringToday>.ConfigureSupplementaryView = { _, collectionView, kindOfView, indexPath in
      let footerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kindOfView,
        withReuseIdentifier: "FooterReusableView", for: indexPath) as! FooterReusableView
      return footerView
    }

    return (configureCell, configureFooterView)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AiringTodayRootView: UICollectionViewDelegateFlowLayout {

  public func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    return CGSize(width: width, height: 275)
  }

  public func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             referenceSizeForFooterInSection section: Int) -> CGSize {
    let viewState = viewModel.getCurrentViewState()

    switch viewState {
    case .paging:
      return CGSize(width: collectionView.frame.width, height: 100)
    default:
      return .zero
    }
  }
}
