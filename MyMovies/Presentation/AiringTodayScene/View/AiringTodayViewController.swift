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

class AiringTodayViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  private var viewModel: AiringTodayViewModel!
  private var airingTodayViewControllersFactory: AiringTodayViewControllersFactory!
  
  static func create(with viewModel: AiringTodayViewModel,
                     airingTodayViewControllersFactory: AiringTodayViewControllersFactory) -> AiringTodayViewController {
    let controller = AiringTodayViewController.instantiateViewController()
    controller.viewModel = viewModel
    controller.airingTodayViewControllersFactory = airingTodayViewControllersFactory
    return controller
  }
  
  fileprivate let disposeBag = DisposeBag()
  
  //MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    viewModel.getShows(for: 1)
  }
  
  // MARK: - SetupView
  
  func setupUI() {
    navigationItem.title = "Today on TV"
    setupCollectionView()
  }
  
  // MARK: - Setup CollectionView
  
  func setupCollectionView() {
    let nibName = UINib(nibName: "AiringTodayCollectionViewCell", bundle: nil)
    collectionView.register(nibName, forCellWithReuseIdentifier: "AiringTodayCollectionViewCell")
    collectionView.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter , withReuseIdentifier: "FooterReusableView")
    collectionView.backgroundColor = UIColor.groupTableViewBackground
    
    let (configureCollectionViewCell, configureSupplementaryView) = configureCollectionViewDataSource()
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionAiringToday>(
      configureCell: configureCollectionViewCell,
      configureSupplementaryView: configureSupplementaryView)
    
    viewModel.output
      .viewState
      .map { [SectionAiringToday(header: "Shows Today", items: $0.currentEntities) ] }
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    collectionView.rx
      .modelSelected( TVShow.self)
      .subscribe(onNext: { [weak self] tvShow in
        guard let strongSelf = self else { return }
        strongSelf.handle( tvShow.id )
      })
      .disposed(by: disposeBag)
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AiringTodayCollectionViewCell", for: indexPath) as! AiringTodayCollectionViewCell
        cell.viewModel = self?.viewModel.getModelFor(item)
        print("retornar cell: \(indexPath)")
        
        // MARK: - TODO viewState dont be here !!
        if case .paging(_, let nextPage) = try? strongSelf.viewModel.viewStateObservableSubject.value(),
          let totalItems = dataSource.sectionModels.first?.items.count, indexPath.row == totalItems - 1 {
          strongSelf.viewModel.getShows(for: nextPage)
        }
        
        return cell
      }
      
      let configureFooterView: CollectionViewSectionedDataSource<SectionAiringToday>.ConfigureSupplementaryView = {
        dataSource, collectionView, kindOfView, indexPath in
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kindOfView, withReuseIdentifier: "FooterReusableView", for: indexPath) as! FooterReusableView
        return footerView
      }
      
      return (configureCell, configureFooterView)
  }
  
}


// MARK: - UICollectionViewDelegateFlowLayout

extension AiringTodayViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    return CGSize(width: width, height: 275)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    
    // MARK: - TODO  dont be here
    guard let state = try? viewModel.viewStateObservableSubject.value() else { return .zero }
    
    switch state {
    case .loading, .paging(_, _):
      return CGSize(width: collectionView.frame.width, height: 100)
    default:
      return .zero
    }
  }
}


//MARK: - TODO, implementar Coordinator Pattern

extension AiringTodayViewController {
  
  func handle(_ route: Int?) {
    guard let identifier = route else { return }
    let detailController = airingTodayViewControllersFactory.makeTVShowDetailsViewController(with: identifier)
    navigationController?.pushViewController(detailController, animated: true)
  }
}

// MARK: - AiringTodayViewControllersFactory

protocol AiringTodayViewControllersFactory {
  
  func makeTVShowDetailsViewController(with identifier: Int) -> UIViewController
}
