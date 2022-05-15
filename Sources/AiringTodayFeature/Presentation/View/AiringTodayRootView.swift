//
//  AiringTodayRootView.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 8/21/20.
//

import UIKit
import Combine
import Shared

class AiringTodayRootView: NiblessView {

  private let viewModel: AiringTodayViewModelProtocol

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

  private var disposeBag = Set<AnyCancellable>()

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

  private func setupUI() {
    setupCollectionView()
    setupDataSource()
  }

  // MARK: - Setup CollectionView
  private func setupCollectionView() {
    collectionView.refreshControl = DefaultRefreshControl(refreshHandler: { [weak self] in
      self?.viewModel.refreshView()
    })

    collectionView.registerCell(cellType: AiringTodayCollectionViewCell.self)
    collectionView.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: "FooterReusableView")
    collectionView.delegate = self

    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                    cellProvider: { [weak self] collectionView, indexPath, viewModel in
      let cell = collectionView.dequeueReusableCell(with: AiringTodayCollectionViewCell.self, for: indexPath)
      cell.setViewModel(viewModel)

      // MARK: - TODO, Use willDisplayCell and trigger signal to ViewModel instead
      if let totalItems = self?.dataSource?.snapshot().itemIdentifiers(inSection: .shows).count, indexPath.row == totalItems - 1 {
        self?.viewModel.didLoadNextPage()
      }

      return cell
    })

    dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
      let footerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: "FooterReusableView", for: indexPath) as! FooterReusableView
      return footerView
    }
  }

  private func setupDataSource() {
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

  override func layoutSubviews() {
    super.layoutSubviews()
    collectionView.frame = bounds
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AiringTodayRootView: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    return CGSize(width: width, height: 275)
  }

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
}
