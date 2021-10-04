//
//  SignInViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxSwift
import Shared

class SignInViewModel: SignInViewModelProtocol {

  private let createTokenUseCase: CreateTokenUseCase

  private let viewStateSubject: BehaviorSubject<SignInViewState> = .init(value: .initial)

  private let disposeBag = DisposeBag()

  weak var delegate: SignInViewModelDelegate?

  let tapButton = PublishSubject<Void>()

  let viewState: Observable<SignInViewState>

  // MARK: - Initializers
  init(createTokenUseCase: CreateTokenUseCase) {
    self.createTokenUseCase = createTokenUseCase
    viewState = viewStateSubject.asObservable()
    subscribe()
  }

  // MARK: - Public
  public func changeState(with state: SignInViewState) {
    viewStateSubject.onNext(state)
  }

  // MARK: - Private
  fileprivate func subscribe() {
    // MARK: - TODO, test handle several taps
    tapButton
      .flatMap { [weak self] () -> Observable<URL> in
        guard let strongSelf = self else { return Observable.error(CustomError.genericError)}
        self?.viewStateSubject.onNext(.loading)
        return strongSelf.requestCreateToken()
    }
    .subscribe(onNext: { [weak self] url in
      guard let strongSelf = self else { return }
      strongSelf.delegate?.signInViewModel(strongSelf, didTapSignInButton: url)
  
      }, onError: { [weak self] error in
        print("error to request token: \(error)")
        self?.viewStateSubject.onNext(.loading)
    })
      .disposed(by: disposeBag)
  }

  fileprivate func requestCreateToken() -> Observable<URL> {
    return createTokenUseCase.execute()
  }
}
