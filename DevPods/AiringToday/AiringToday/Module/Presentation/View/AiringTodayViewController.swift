//
//  AiringTodayViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import Shared

class AiringTodayViewController: NiblessViewController, Loadable, Retryable, Emptiable {
  
  private var viewModel: AiringTodayViewModelProtocol
  
  private let disposeBag = DisposeBag()
  
  init(viewModel: AiringTodayViewModelProtocol) {
    self.viewModel = viewModel
    super.init()
  }
  
  // MARK: - Life Cycle
  
  override func loadView() {
    view = AiringTodayRootView(viewModel: viewModel)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    subscribeToViewState()
    viewModel.viewDidLoad()
  }
  
  fileprivate func subscribeToViewState() {
    viewModel
      .viewState
      .subscribe(onNext: { [weak self] viewstate in
        self?.handleViewState(with: viewstate)
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func handleViewState(with state: SimpleViewState<AiringTodayCollectionViewModel>) {
    stopRefresh()
    
    switch state {
    case .loading:
      showLoadingView()
      hideMessageView()
      
    case .empty:
      hideLoadingView()
      showEmptyView(with: "No shows for Today")
      
    case .error(let message):
      hideLoadingView()
      showMessageView(with: message,
                      errorHandler: { [weak self] in
                        self?.viewModel.refreshView()
      })
      
    default:
      hideLoadingView()
      hideMessageView()
    }
  }
  
  fileprivate func stopRefresh() {
    (view as! AiringTodayRootView).stopRefresh()
  }
}
