//
//  AiringTodayViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import Shared

class AiringTodayViewController: UIViewController, StoryboardInstantiable, Loadable {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  private var viewModel: AiringTodayViewModel!
  
  static func create(with viewModel: AiringTodayViewModel) -> AiringTodayViewController {
    let controller = AiringTodayViewController.instantiateViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  lazy var messageView = MessageView(message: "")
  
  fileprivate let disposeBag = DisposeBag()
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    viewModel.getShows(for: 1)
  }
  
  // MARK: - SetupView
  
  func setupUI() {
    navigationItem.title = "Today on TV"
    
    setupViews()
    setupCollectionView()
    setupDataSource()
    handleSelectionItems()
    subscribeToViewState()
  }
  
  fileprivate func setupViews() {
    messageView.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 100)
  }
  
  // MARK: - Setup CollectionView
  
  fileprivate func setupCollectionView() {
    collectionView.registerNib(cellType: AiringTodayCollectionViewCell.self)
    
    collectionView.register(FooterReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: "FooterReusableView")
    collectionView.backgroundColor = UIColor.groupTableViewBackground
    
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  fileprivate func setupDataSource() {
    let (configureCollectionViewCell, configureSupplementaryView) = configureCollectionViewDataSource()
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionAiringToday>(
      configureCell: configureCollectionViewCell,
      configureSupplementaryView: configureSupplementaryView)
    
    viewModel.output
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
        strongSelf.viewModel.navigateTo(step: AiringTodayStep.showIsPicked(withId: item.show.id ) )
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func subscribeToViewState() {
    viewModel.output
      .viewState
      .subscribe(onNext: { [weak self] viewstate in
        self?.handleViewState(with: viewstate)
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func handleViewState(with state: SimpleViewState<AiringTodayCollectionViewModel>) {
    
    hideLoadingView()
    
    switch state {
    case .loading:
      showLoadingView()
      
    default:
      break
    }
  }
}

// MARK: - Configure CollectionView Views

extension AiringTodayViewController {
  
  func configureCollectionViewDataSource() -> (
    CollectionViewSectionedDataSource<SectionAiringToday>.ConfigureCell,
    CollectionViewSectionedDataSource<SectionAiringToday>.ConfigureSupplementaryView
    ) {
      let configureCell: CollectionViewSectionedDataSource<SectionAiringToday>.ConfigureCell = {
        [weak self] dataSource, collectionView, indexPath, item in
        guard let strongSelf = self else { fatalError() }
        
        let cell = collectionView.dequeueReusableCell(with: AiringTodayCollectionViewCell.self, for: indexPath)
        cell.viewModel = item
        
        if case .paging(_, let nextPage) = strongSelf.viewModel.getCurrentViewState(),
          let totalItems = dataSource.sectionModels.first?.items.count, indexPath.row == totalItems - 1 {
          strongSelf.viewModel.getShows(for: nextPage)
        }
        
        return cell
      }
      
      let configureFooterView: CollectionViewSectionedDataSource<SectionAiringToday>.ConfigureSupplementaryView = {
        dataSource, collectionView, kindOfView, indexPath in
        let footerView = collectionView.dequeueReusableSupplementaryView(
          ofKind: kindOfView,
          withReuseIdentifier: "FooterReusableView", for: indexPath) as! FooterReusableView
        return footerView
      }
      
      return (configureCell, configureFooterView)
  }
  
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AiringTodayViewController: UICollectionViewDelegateFlowLayout {
  
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
}
