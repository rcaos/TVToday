//
//  AiringTodayRootView.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 8/21/20.
//

import Shared
import UIKit
import RxSwift

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
    collectionView.backgroundColor = .systemBackground
    return collectionView
  }()

  private var dataSource: DataSource?

  typealias DataSource = UICollectionViewDiffableDataSource<SectionAiringTodayFeed, AiringTodayCollectionViewModel>
  typealias Snapshot = NSDiffableDataSourceSnapshot<SectionAiringTodayFeed, AiringTodayCollectionViewModel>

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
    collectionView.refreshControl = DefaultRefreshControl(refreshHandler: { [weak self] in
      self?.viewModel.refreshView()
    })

    collectionView.register(AiringTodayCollectionViewCell.self, forCellWithReuseIdentifier: "AiringTodayCollectionViewCell")
    collectionView.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: "FooterReusableView")
    collectionView.delegate = self

    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                    cellProvider: { [weak self] collectionView, indexPath, viewModel in
      let cell = collectionView.dequeueReusableCell(with: AiringTodayCollectionViewCell.self, for: indexPath)
      cell.setViewModel(viewModel)

      // MARK: - TODO
      //      if let totalItems = dataSource.sectionModels.first?.items.count, indexPath.row == totalItems - 1 {
      //        strongSelf.viewModel.didLoadNextPage()
      //      }
      return cell
    })

    dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
      let footerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: "FooterReusableView", for: indexPath) as! FooterReusableView
      return footerView
    }
  }

  fileprivate func setupDataSource() {
    viewModel
      .viewState
      .map { $0.currentEntities }
      .map { entities -> Snapshot in
        var snapShot = Snapshot()
        let section = SectionAiringTodayFeed.shows(shows: entities)
        snapShot.appendSections([section])
        snapShot.appendItems(entities, toSection: section)
        return snapShot
      }
      .subscribe(onNext: { [weak self] snapshot in
        self?.dataSource?.apply(snapshot)
      })
      .disposed(by: disposeBag)
  }

  fileprivate func handleSelectionItems() {
    //    collectionView.rx
    //      .modelSelected( AiringTodayCollectionViewModel.self)
    //      .subscribe(onNext: { [weak self] item in
    //        guard let strongSelf = self else { return }
    //        strongSelf.viewModel.showIsPicked(with: item.show.id)
    //      })
    //      .disposed(by: disposeBag)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    collectionView.frame = bounds
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
