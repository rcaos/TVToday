//
//  SignInViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Combine
import RxSwift
import Shared
import NetworkingInterface

class SignInViewModel: SignInViewModelProtocol {

  private let createTokenUseCase: CreateTokenUseCase

  private let viewStateSubject: BehaviorSubject<SignInViewState> = .init(value: .initial)

  private let disposeBag = DisposeBag()
  private var cancelables = Set<AnyCancellable>()

  weak var delegate: SignInViewModelDelegate?

  private let tapButton = PassthroughSubject<Void, Never>()

  let viewState: Observable<SignInViewState>

  // MARK: - Initializers
  init(createTokenUseCase: CreateTokenUseCase) {
    self.createTokenUseCase = createTokenUseCase
    viewState = viewStateSubject.asObservable()
    subscribe()
  }

  // MARK: - Public
  func signInDidTapped() {
    tapButton.send(())
  }

  public func changeState(with state: SignInViewState) {
    viewStateSubject.onNext(state)
  }

  // MARK: - Private
  private func subscribe() {
    // MARK: - TODO, test handle several taps
    tapButton
      .flatMap { [viewStateSubject, createTokenUseCase] () -> AnyPublisher<URL, DataTransferError> in
        viewStateSubject.onNext(.loading)
        return createTokenUseCase.execute()
      }
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case let .failure(error):
          print("error to request token: \(error)")
          self?.viewStateSubject.onNext(.loading)
        case .finished:
          break
        }
      },
            receiveValue: { [weak self] url in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.signInViewModel(strongSelf, didTapSignInButton: url)
      })
      .store(in: &cancelables)
  }
}
