//
//  AiringTodayRootViewCompositional.swift
//  
//
//  Created by Jeans Ruiz on 23/05/22.
//

import UIKit
import Combine
import UI

class AiringTodayRootViewCompositional: NiblessView, AiringTodayRootViewProtocol {

  private let viewModel: AiringTodayViewModelProtocol

  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()

  private var dataSource: DataSource?

  typealias DataSource = UICollectionViewDiffableDataSource<SectionAiringTodayFeed, AiringTodayCollectionViewModel>
  typealias Snapshot = NSDiffableDataSourceSnapshot<SectionAiringTodayFeed, AiringTodayCollectionViewModel>

  private var disposeBag = Set<AnyCancellable>()

  // MARK: - Initializer
  init(frame: CGRect = .zero, viewModel: AiringTodayViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)
    setupUI()
  }

  func stopRefresh() {
    collectionView.refreshControl?.endRefreshing(with: 0.5)
  }

  private func setupUI() {
    addToHierarchy()
    setupFlowLayout()
    setupCollectionView()
    setupCollectionDataSource()
    subscribeToDataSource()
  }

  private func addToHierarchy() {
    addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.pin(to: self)
  }

  private func setupFlowLayout() {
    let size = NSCollectionLayoutSize(
      widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
      heightDimension: NSCollectionLayoutDimension.estimated(100)
    )
    let item = NSCollectionLayoutItem(layoutSize: size)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    section.interGroupSpacing = 10

    let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44)),
      elementKind: UICollectionView.elementKindSectionFooter,
      alignment: .bottom)

    section.boundarySupplementaryItems = [sectionFooter]

    let layout = UICollectionViewCompositionalLayout(section: section)
    collectionView.collectionViewLayout = layout
  }

  private func setupCollectionView() {
    collectionView.refreshControl = DefaultRefreshControl(refreshHandler: { [weak self] in
      self?.viewModel.refreshView()
    })

    collectionView.registerCell(cellType: AiringTodayCollectionViewCell.self)
    collectionView.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: "FooterReusableView")
    collectionView.delegate = self
    collectionView.contentInsetAdjustmentBehavior = .always
    collectionView.backgroundColor = .systemBackground
  }

  private func setupCollectionDataSource() {
    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                    cellProvider: { collectionView, indexPath, viewModel in
      let cell = collectionView.dequeueReusableCell(with: AiringTodayCollectionViewCell.self, for: indexPath)
      cell.setViewModel(viewModel)
      return cell
    })

    dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
      if kind == UICollectionView.elementKindSectionFooter {
        let footerView = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: "FooterReusableView", for: indexPath) as! FooterReusableView
        return footerView
      } else {
        return nil
      }
    }
  }

  private func subscribeToDataSource() {
    viewModel
      .viewStateObservableSubject
      .map { $0.currentEntities }
      .map { entities -> Snapshot in
        var snapShot = Snapshot()
        snapShot.appendSections([.shows])
        snapShot.appendItems(entities, toSection: .shows)
        return snapShot
      }
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] snapshot in
        self?.dataSource?.apply(snapshot)
      })
      .store(in: &disposeBag)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AiringTodayRootViewCompositional: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,
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

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.showIsPicked(index: indexPath.row)
  }

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//    let totalItems = dataSource?.snapshot().numberOfItems(inSection: .shows) ?? 0
//    viewModel.willDisplayRow(indexPath.row, outOf: totalItems)
  }
}
