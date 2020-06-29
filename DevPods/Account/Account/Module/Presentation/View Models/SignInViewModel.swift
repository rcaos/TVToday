//
//  SignInViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxSwift

protocol SignInViewModelDelegate: class {
  
  func signInViewModel(_ signInViewModel: SignInViewModel, didTapSignInButton tapped: Bool)
}

class SignInViewModel {
  
  weak var delegate: SignInViewModelDelegate?
  
  private let viewStateSubject: BehaviorSubject<ViewState> = .init(value: .initial)
  
  var input: Input
  
  var output: Output
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  init() {
    input = Input()
    output = Output(viewState: viewStateSubject.asObservable())
    
    subscribe()
  }
  
  // MARK: - Public
  
  public func changeState(with state: SignInViewModel.ViewState) {
    viewStateSubject.onNext(state)
  }
  
  // MARK: - Private
  
  fileprivate func subscribe() {
    input.tapButton.asObserver()
      .subscribe(onNext: { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.viewStateSubject.onNext(.loading)
        strongSelf.delegate?.signInViewModel(strongSelf, didTapSignInButton: true)
      })
      .disposed(by: disposeBag)
  }
}

extension SignInViewModel {
  
  public struct Input {
    let tapButton = PublishSubject<Void>()
  }
  
  public struct Output {
    let viewState: Observable<ViewState>
  }
}

extension SignInViewModel {
  
  enum ViewState {
    case initial,
    
    loading
  }
}
