//
//  Created by Jeans Ruiz on 8/21/20.
//

import UIKit
import Combine
import UI

protocol AiringTodayRootViewProtocol {
  func stopRefresh()
}

class AiringTodayRootView: NiblessView, AiringTodayRootViewProtocol {

  private let viewModel: AiringTodayViewModelProtocol
  private let customFlowLayout = CustomFlowLayout()

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: customFlowLayout)
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
    customFlowLayout.sectionInsetReference = .fromContentInset
    customFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    customFlowLayout.minimumInteritemSpacing = 10
    customFlowLayout.minimumLineSpacing = 10
    customFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    customFlowLayout.headerReferenceSize = .zero
    customFlowLayout.footerReferenceSize = CGSize(width: 0, height: 100)

    customFlowLayout.scrollDirection = .vertical
  }

  private func setupCollectionView() {
    collectionView.refreshControl = DefaultRefreshControl(refreshHandler: { [weak self] in
      Task {
        await self?.viewModel.refreshView()
      }
    })

    collectionView.registerCell(cellType: AiringTodayCollectionViewCell.self)
    collectionView.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: "FooterReusableView")
    collectionView.delegate = self

    collectionView.collectionViewLayout = customFlowLayout
    collectionView.contentInsetAdjustmentBehavior = .always
    collectionView.backgroundColor = .systemBackground
  }

  private func setupCollectionDataSource() {
    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                    cellProvider: { [weak self] collectionView, indexPath, viewModel in
      let cell = collectionView.dequeueReusableCell(with: AiringTodayCollectionViewCell.self, for: indexPath)
      cell.setViewModel(viewModel)

      // MARK: - TODO, Use willDisplayCell and trigger signal to ViewModel instead
      let totalItems = self?.dataSource?.snapshot().itemIdentifiers(inSection: .shows).count ?? 0
      
      Task {
        await self?.viewModel.willDisplayRow(indexPath.row, outOf: totalItems)
      }

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
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] snapshot in
        self?.dataSource?.apply(snapshot)
      })
      .store(in: &disposeBag)
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    customFlowLayout.invalidateLayout()
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AiringTodayRootView: UICollectionViewDelegateFlowLayout {

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
